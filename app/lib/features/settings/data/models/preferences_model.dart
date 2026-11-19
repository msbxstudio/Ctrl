import 'package:flutter/foundation.dart';
import 'package:ctrl/features/settings.dart';

@immutable
final class PreferencesModel {
  const new({required this.language, required this.allowSounds});

  /// The preferred application language.
  final AppLanguage language;

  /// Whether notifications are enabled.
  final bool allowSounds;

  /// Creates a model from a JSON object.
  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      language: AppLanguage.fromDbValue(map['language'] as String),
      allowSounds: map['allow_sounds'] as bool,
    );
  }

  /// Creates a model from a domain entity.
  factory PreferencesModel.fromEntity(Preferences entity) {
    return PreferencesModel(
      language: entity.language,
      allowSounds: entity.allowSounds,
    );
  }

  /// Converts the model to a JSON object.
  Map<String, dynamic> toMap() {
    return {'language': language.toDbValue(), 'allow_sounds': allowSounds};
  }

  /// Converts the model to a domain entity.
  Preferences toEntity() {
    return Preferences(language: language, allowSounds: allowSounds);
  }
}
