import 'package:ctrl/features/settings.dart';

/// Defines local persistence operations for user preferences.
abstract interface class SharedPreferencesDataSource {
  /// Retrieves locally stored preferences.
  ///
  /// Returns null if no preferences have been stored.
  Future<PreferencesModel?> get();

  /// Saves the given preferences to local storage.
  Future<void> save(PreferencesModel model);

  /// Removes locally stored preferences.
  Future<void> delete();

  Future<void> reset();
}
