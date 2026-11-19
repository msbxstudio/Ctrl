import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/features/player.dart';
import 'package:ctrl/features/settings.dart';

/// Controller for [SettingsPage] view.
final class SettingsController extends AutoDisposeAsyncNotifier<SettingsData> {
  @override
  Future<SettingsData> build() async {
    final preferences = ref.watch(preferencesNotifierProvider);
    final player = await ref.read(playerRepositoryProvider).get();

    return (
      player: player,
      langCode: preferences.language.toDbValue(),
      soundEffects: preferences.allowSounds,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Updates the player's name.
  Future<void> updateName({required String name}) async {
    await ref.read(playerRepositoryProvider).update(name: name);
    await refresh();
  }

  /// Updates the preferred application language.
  Future<void> updateLanguage(
    BuildContext context, {
    required String languageCode,
  }) async {
    final language = AppLanguage.fromDbValue(languageCode);

    await ref.read(preferencesNotifierProvider.notifier).setLanguage(language);

    if (!context.mounted) return;

    await context.setLocale(Locale(languageCode));
  }

  /// Enables or disables sound effects.
  Future<void> updateSound({required bool sound}) async {
    await ref.read(preferencesNotifierProvider.notifier).setAllowSounds(sound);
  }
}
