import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:ctrl/features/level.dart';

/// Supplies an asset path without accessing the device filesystem.
final class _TestAudioCache extends AudioCache {
  @override
  Future<String> loadPath(String fileName) async => '/success.mp3';
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;
  const channelName = 'xyz.luan/audioplayers';
  const sessionChannelName = 'dev.msbx.ctrl/sound_effect_audio';
  final calls = <MethodCall>[];
  final sinks = <String, MockStreamHandlerEventSink>{};
  late AudioCache originalCache;
  var failSetup = false;
  var failActivation = false;
  var failDisposal = false;

  setUpAll(() async {
    messenger.setMockMethodCallHandler(
      const MethodChannel('$channelName.global'),
      (_) async => null,
    );
    messenger.setMockStreamHandler(
      const EventChannel('$channelName.global/events'),
      MockStreamHandler.inline(onListen: (_, events) {}),
    );
    await AudioPlayer.global.ensureInitialized();
  });

  setUp(() {
    calls.clear();
    sinks.clear();
    failSetup = false;
    failActivation = false;
    failDisposal = false;
    originalCache = AudioCache.instance;
    AudioCache.instance = _TestAudioCache();
    messenger.setMockMethodCallHandler(
      const MethodChannel(sessionChannelName),
      (
        call,
      ) async {
        calls.add(call);
        if (call.method == 'beginEffect' && failActivation) {
          throw PlatformException(code: 'audio_activation_failed');
        }
        return null;
      },
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('$channelName.global'),
      (_) async => null,
    );
    messenger.setMockStreamHandler(
      const EventChannel('$channelName.global/events'),
      MockStreamHandler.inline(onListen: (_, events) {}),
    );
    messenger.setMockMethodCallHandler(const MethodChannel(channelName), (
      call,
    ) async {
      calls.add(call);
      final arguments = call.arguments as Map;
      final id = arguments['playerId'] as String;
      if (call.method == 'create') {
        messenger.setMockStreamHandler(
          EventChannel('$channelName/events/$id'),
          MockStreamHandler.inline(
            onListen: (_, events) {
              sinks[id] = events;
            },
          ),
        );
      } else if (call.method == 'setAudioContext' && failSetup) {
        throw PlatformException(code: 'audio_setup_failed');
      } else if (call.method == 'setSourceUrl') {
        sinks[id]!.success({'event': 'audio.onPrepared', 'value': true});
      } else if (call.method == 'getCurrentPosition') {
        return 0;
      } else if (call.method == 'dispose' && failDisposal) {
        throw PlatformException(code: 'audio_disposal_failed');
      }
      return null;
    });
  });

  tearDown(() {
    AudioCache.instance = originalCache;
  });

  Future<void> flushAudio(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    }
  }

  Future<void> showCompletion(
    WidgetTester tester, {
    bool soundEffects = true,
  }) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    showLevelCompletedDialog(context, allowSounds: soundEffects).ignore();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await flushAudio(tester);
  }

  testWidgets(
    'ducks music during the effect and restores it after releasing the player',
    (
      tester,
    ) async {
      await showCompletion(tester);

      final context = calls.singleWhere((c) => c.method == 'setAudioContext');
      expect(context.arguments['category'], 'playback');
      expect(context.arguments['options'], ['duckOthers']);
      expect(
        calls.indexOf(context),
        lessThan(calls.indexWhere((c) => c.method == 'resume')),
      );
      final begin = calls.indexWhere((c) => c.method == 'beginEffect');
      expect(
        begin,
        greaterThan(calls.indexWhere((c) => c.method == 'setSourceUrl')),
      );
      expect(begin, lessThan(calls.indexWhere((c) => c.method == 'resume')));
      expect(calls.where((c) => c.method == 'dispose'), isEmpty);
      expect(calls.where((c) => c.method == 'endEffect'), isEmpty);

      sinks.values.single.success({'event': 'audio.onComplete'});
      await tester.pumpAndSettle();
      await flushAudio(tester);

      expect(
        calls.where((c) => c.method == 'dispose'),
        hasLength(1),
        reason: calls.map((c) => c.method).join(', '),
      );
      expect(calls.where((c) => c.method == 'endEffect'), hasLength(1));
      expect(
        calls.indexWhere((c) => c.method == 'endEffect'),
        greaterThan(calls.indexWhere((c) => c.method == 'dispose')),
      );
      expect(find.byType(Dialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('releases the player when audio setup fails', (tester) async {
    failSetup = true;
    await showCompletion(tester);

    expect(calls.where((c) => c.method == 'resume'), isEmpty);
    expect(calls.where((c) => c.method == 'dispose'), hasLength(1));
    expect(calls.where((c) => c.method == 'beginEffect'), isEmpty);
    expect(calls.where((c) => c.method == 'endEffect'), isEmpty);
    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('releases the player on a playback error', (tester) async {
    await showCompletion(tester);
    sinks.values.single.error(code: 'playback_failed');
    await flushAudio(tester);
    await tester.pumpAndSettle();

    expect(calls.where((c) => c.method == 'dispose'), hasLength(1));
    expect(calls.where((c) => c.method == 'endEffect'), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('releases the player if no completion event arrives', (
    tester,
  ) async {
    await showCompletion(tester);
    await tester.pump(const Duration(seconds: 10));
    await flushAudio(tester);
    await tester.pumpAndSettle();

    expect(calls.where((c) => c.method == 'dispose'), hasLength(1));
    expect(calls.where((c) => c.method == 'endEffect'), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not end another effect session if activation fails', (
    tester,
  ) async {
    failActivation = true;
    await showCompletion(tester);

    expect(calls.where((c) => c.method == 'beginEffect'), hasLength(1));
    expect(calls.where((c) => c.method == 'resume'), isEmpty);
    expect(calls.where((c) => c.method == 'dispose'), hasLength(1));
    expect(calls.where((c) => c.method == 'endEffect'), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('restores the audio session even if player disposal fails', (
    tester,
  ) async {
    failDisposal = true;
    await showCompletion(tester);
    sinks.values.single.success({'event': 'audio.onComplete'});
    await flushAudio(tester);
    await tester.pumpAndSettle();

    expect(calls.where((c) => c.method == 'endEffect'), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not create a player when sound effects are disabled', (
    tester,
  ) async {
    await showCompletion(tester, soundEffects: false);

    expect(calls, isEmpty);
    expect(find.byType(Dialog), findsOneWidget);
  });
}
