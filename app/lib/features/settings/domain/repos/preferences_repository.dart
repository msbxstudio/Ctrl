import 'package:ctrl/features/settings.dart';

abstract interface class PreferencesRepository {
  Future<Preferences> get();

  Future<Preferences> update({AppLanguage language, bool allowSounds});

  Future<Preferences> reset();
}
