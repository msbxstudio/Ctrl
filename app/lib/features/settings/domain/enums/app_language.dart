import 'package:msbx/exceptions.dart';

enum AppLanguage {
  ///
  es,

  ///
  en;

  /// Localization key for this language's display name.
  String get labelKey => 'settings.languages.$name';

  static AppLanguage fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'ES' => AppLanguage.es,
      'EN' => AppLanguage.en,
      _ => throw const ValidationException('errors.settings.language'),
    };
  }

  String toDbValue() {
    return switch (this) {
      es => 'ES',
      en => 'EN',
    };
  }
}
