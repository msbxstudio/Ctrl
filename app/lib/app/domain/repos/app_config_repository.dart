import 'package:ctrl/app/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AppConfigRepository extends StateNotifier<AppConfig> {
  AppConfigRepository() : super(AppConfigModel.initial());

  void setTheme(ThemeMode mode);

  void setLocale(String code);

  void setSoundEffects(bool enabled);
}
