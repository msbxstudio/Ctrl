import 'package:ctrl/app/index.dart';
import 'package:flutter/material.dart';

final class AppConfigModel extends AppConfig {
  const AppConfigModel({required super.locale});

  factory AppConfigModel.initial() {
    return const AppConfigModel(locale: Locale('es'));
  }

  @override
  AppConfigModel copyWith({Locale? locale}) {
    return AppConfigModel(locale: locale ?? this.locale);
  }
}
