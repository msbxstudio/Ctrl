import 'package:ctrl/app/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppConfigRepositoryImpl extends AppConfigRepository {
  static const _kLocaleKey = '__locale_mode__';
  static const _kSoundEffectsKey = '__sound_effects__';

  final SharedPreferences _prefs;

  AppConfigRepositoryImpl(this._prefs) : super() {
    final currentLocale = _prefs.getString(_kLocaleKey);
    final currentSoundEffects = _prefs.getBool(_kSoundEffectsKey);

    state = (state as AppConfigModel).copyWith(
      locale: Locale(currentLocale ?? 'en'),
      soundEffects: currentSoundEffects ?? true,
    );
  }

  @override
  void setTheme(ThemeMode mode) {
    throw UnimplementedError();
  }

  @override
  void setLocale(String code) {
    _prefs.setString(_kLocaleKey, code);
    state = state.copyWith(locale: Locale(code));
  }

  @override
  void setSoundEffects(bool enabled) {
    _prefs.setBool(_kSoundEffectsKey, enabled);
    state = state.copyWith(soundEffects: enabled);
  }
}
