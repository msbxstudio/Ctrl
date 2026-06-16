import 'package:ctrl/app/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppConfigRepositoryImpl extends AppConfigRepository {
  static const _kLocaleKey = '__locale_mode__';

  final SharedPreferences _prefs;

  AppConfigRepositoryImpl(this._prefs) : super() {
    final currentLocale = _prefs.getString(_kLocaleKey);

    state = (state as AppConfigModel).copyWith(
      locale: Locale(currentLocale ?? 'en'),
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
  void setNotifications(bool enabled) {
    throw UnimplementedError();
  }
}
