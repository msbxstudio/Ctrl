import 'package:ctrl/features/settings.dart';

final class PreferencesRepositoryImpl implements PreferencesRepository {
  ///
  const new(this._shared);

  ///
  final SharedPreferencesDataSource _shared;

  @override
  Future<Preferences> get() async {
    final value = await _shared.get();
    return value?.toEntity() ?? const Preferences.defaults();
  }

  @override
  Future<Preferences> update({AppLanguage? language, bool? allowSounds}) async {
    final current = await get();

    final updated = Preferences(
      language: language ?? current.language,
      allowSounds: allowSounds ?? current.allowSounds,
    );

    await _shared.save(PreferencesModel.fromEntity(updated));

    return updated;
  }

  @override
  Future<Preferences> reset() async {
    const defaults = Preferences.defaults();

    await _shared.save(PreferencesModel.fromEntity(defaults));

    return defaults;
  }
}
