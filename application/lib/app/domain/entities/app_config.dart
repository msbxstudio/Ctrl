import 'package:ctrl/core/utils/index.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppConfig implements Copyable<AppConfig> {
  final Locale locale;
  final bool soundEffects;

  const AppConfig({required this.locale, required this.soundEffects});

  @override
  AppConfig copyWith({Locale? locale, bool? soundEffects});
}
