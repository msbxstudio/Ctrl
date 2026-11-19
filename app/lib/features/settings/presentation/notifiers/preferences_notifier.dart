import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/features/settings.dart';

/// Manages application preferences and persists their changes.
final class PreferencesNotifier extends StateNotifier<Preferences> {
  /// Creates the notifier with the default application preferences.
  new(this._repository) : super(Preferences.defaults());

  final PreferencesRepository _repository;

  /// Loads the stored application preferences.
  Future<void> load() async {
    final preferences = await _repository.get();

    if (mounted) {
      state = preferences;
    }
  }

  /// Updates the preferred application language.
  Future<void> setLanguage(AppLanguage language) async {
    final preferences = await _repository.update(language: language);

    if (mounted) {
      state = preferences;
    }
  }

  /// Enables or disables application sounds.
  Future<void> setAllowSounds(bool value) async {
    final preferences = await _repository.update(allowSounds: value);

    if (mounted) {
      state = preferences;
    }
  }

  /// Restores the default application preferences.
  Future<void> reset() async {
    final preferences = await _repository.reset();

    if (mounted) {
      state = preferences;
    }
  }
}
