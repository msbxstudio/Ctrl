import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';

import 'package:ctrl/features/player.dart';
import 'package:ctrl/features/settings.dart';

/// Controller for [SettingsPage] view.
final class SettingsController extends AutoDisposeAsyncNotifier<SettingsState>
    implements Refreshable {
  @override
  Future<SettingsState> build() async {
    final preferences = ref.watch(preferencesNotifierProvider);
    final player = await ref.read(playerRepositoryProvider).get();

    return SettingsState(
      player: player,
      language: preferences.language,
      allowSoundEffects: preferences.allowSounds,
    );
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Updates the player's name.
  Future<void> updatePlayerName({required String name}) async {
    await ref.read(playerRepositoryProvider).update(name: name);
  }

  /// Enables or disables sound effects.
  Future<void> updateAllowSoundEffects({required bool allow}) async {
    await ref.read(preferencesNotifierProvider.notifier).setAllowSounds(allow);
  }
}
