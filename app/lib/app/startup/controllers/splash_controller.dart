import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/app/startup.dart';
import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/settings.dart';

/// Controller for [SplashPage] view.
final class SplashController extends AutoDisposeAsyncNotifier<SplashState> {
  @override
  FutureOr<SplashState> build() async {
    final preferences =
        await Future.wait([
          /// ...
          ref.read(preferencesRepositoryProvider).get(),

          /// ...
          DatabaseService.initialize(),

          /// ...
          Future.delayed(const Duration(milliseconds: 1500)),
        ], eagerError: true).then((values) {
          return values[0] as Preferences;
        });

    return SplashState(language: preferences.language);
  }
}
