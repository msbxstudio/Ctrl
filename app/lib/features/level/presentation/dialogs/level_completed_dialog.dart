import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:msbx/extensions.dart';

import 'package:ctrl/shared/dialogs.dart';

Future<void> showLevelCompletedDialog(
  BuildContext context, {
  bool soundEffects = true,
  bool rootNavigator = true,
}) {
  final theme = Theme.of(context);

  if (soundEffects) {
    _playSuccessSound().ignore();
  }

  return showAppDialog(
    context,
    fullscreen: true,
    dismissible: false,
    useSafeArea: false,
    constraints: const BoxConstraints(),
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                width: 64.0,
                height: 64.0,

                child: Icon(
                  TablerIcons.check,
                  size: 48.0,
                  color: theme.colorScheme.surface,
                ),
              ),

              const SizedBox(height: 16.0),

              Text(
                'levels.completed.title'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),

              const SizedBox(height: 4.0),

              Text(
                'levels.completed.description'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ).expand(),

          FilledButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },

            child: Text('common.actions.next'.tr()),
          ).aligned(Alignment.center),
        ],
      ).padded(const EdgeInsets.symmetric(horizontal: 24.0)),
    ),
  );
}

/// Temporarily ducks external music on iOS while the victory effect plays.
Future<void> _playSuccessSound() async {
  const audioSession = MethodChannel('dev.msbx.ctrl/sound_effect_audio');
  final usesIOSSession = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  final player = AudioPlayer()..positionUpdater = null;
  final completed = Completer<void>();
  var sessionAcquired = false;

  void finish() {
    if (!completed.isCompleted) completed.complete();
  }

  final subscription = player.onPlayerComplete.listen(
    (_) {
      finish();
    },
    onError: (_, _) {
      finish();
    },
  );

  try {
    await player.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.duckOthers},
        ),
      ),
    );
    // Prepare first so music is ducked only when the effect is ready to play.
    await player.setSource(AssetSource('audio/success.mp3'));
    await player.setVolume(0.2);
    if (usesIOSSession) {
      await audioSession.invokeMethod<void>('beginEffect');
      sessionAcquired = true;
    }
    // The default mediaPlayer mode provides completion events on all platforms.
    await player.resume();
    // The effect lasts 1.6 seconds; also clean up if completion is never sent.
    await completed.future.timeout(const Duration(seconds: 10));
  } finally {
    try {
      await subscription.cancel();
      await player.dispose();
    } finally {
      if (sessionAcquired) {
        await audioSession.invokeMethod<void>('endEffect');
      }
    }
  }
}
