import 'package:msbx/exceptions.dart';

enum AppLanguage {
  ///
  es,

  ///
  en;

  String get label {
    return switch (this) {
      es => 'Español',
      en => 'Inglés',
    };
  }

  static AppLanguage fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'ES' => AppLanguage.es,
      'EN' => AppLanguage.en,
      _ => throw const ValidationException(''),
    };
  }

  String toDbValue() {
    return switch (this) {
      es => 'ES',
      en => 'EN',
    };
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}
