import 'package:ctrl/app/index.dart';
import 'package:ctrl/features/player/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [SettingsPage] view.
final class SettingsController extends AutoDisposeAsyncNotifier<SettingsData> {
  @override
  Future<SettingsData> build() async {
    final player = await ref.read(playerRepositoryProvider).get();
    final appConfig = ref.read(appConfigRepositoryProvider);

    return (
      player: player,
      langCode: appConfig.locale.languageCode.toUpperCase(),
      soundEffects: appConfig.soundEffects,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> updateName({required String name}) async {
    await ref.read(playerRepositoryProvider).update(name: name);
    await refresh();
  }

  Future<void> updateLanguage(
    BuildContext context, {
    required String languageCode,
  }) async {
    ref.read(appConfigRepositoryProvider.notifier).setLocale(languageCode);

    await context.setLocale(Locale(languageCode));
    await refresh();
  }

  Future<void> updateSound({required bool sound}) async {
    ref.read(appConfigRepositoryProvider.notifier).setSoundEffects(sound);
    await refresh();
  }
}

typedef SettingsData = ({Player player, String langCode, bool soundEffects});
