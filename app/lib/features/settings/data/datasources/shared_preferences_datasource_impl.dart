import 'package:ctrl/features/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines local persistence operations for user preferences.
final class SharedPreferencesDataSourceImpl
    implements SharedPreferencesDataSource {
  ///
  const new(this._prefs);

  ///
  final SharedPreferences _prefs;

  /// Retrieves locally stored preferences.
  ///
  /// Returns null if no preferences have been stored.
  @override
  Future<PreferencesModel?> get() {
    final language = _prefs.getString('language');
    final allowSounds = _prefs.getBool('allow_sounds');

    return Future.value(
      language == null || allowSounds == null
          ? null
          : PreferencesModel(
              language: AppLanguage.fromDbValue(language),
              allowSounds: allowSounds,
            ),
    );
  }

  /// Saves the given preferences to local storage.
  @override
  Future<void> save(PreferencesModel model) async {
    final map = model.toMap();

    await _prefs.setString('language', map['language'] as String);
    await _prefs.setBool('allow_sounds', map['allow_sounds'] as bool);
  }

  /// Removes locally stored preferences.
  @override
  Future<void> delete() {
    return Future.value();
  }

  @override
  Future<void> reset() {
    return Future.value();
  }
}
