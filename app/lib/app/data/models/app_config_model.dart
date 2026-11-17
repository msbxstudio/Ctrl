import 'package:ctrl/app/index.dart';
import 'package:flutter/material.dart';

final class AppConfigModel extends AppConfig {
  const AppConfigModel({required super.locale, required super.soundEffects});

  factory AppConfigModel.initial() {
    return const AppConfigModel(locale: Locale('en'), soundEffects: true);
  }

  @override
  AppConfigModel copyWith({Locale? locale, bool? soundEffects}) {
    return AppConfigModel(
      locale: locale ?? this.locale,
      soundEffects: soundEffects ?? this.soundEffects,
    );
  }
}
