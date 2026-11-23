import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';

import 'package:ctrl/app/startup.dart';
import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/settings.dart';

/// Controller for [SplashPage] view.
final class SplashController extends AutoDisposeAsyncNotifier<SplashState>
    implements Refreshable {
  @override
  FutureOr<SplashState> build() async {
    final preferences =
        await Future.wait([
          /// ...
          DatabaseService.initialize(),

          /// ...
          ref.read(preferencesRepositoryProvider).get(),

          /// ...
          Future.delayed(const Duration(milliseconds: 1500)),
        ], eagerError: true).then((values) {
          return values[1] as Preferences;
        });

    return SplashState(language: preferences.language);
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
