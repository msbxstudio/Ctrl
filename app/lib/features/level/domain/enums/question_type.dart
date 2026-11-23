/// Defines how the question text should be interpreted.
enum QuestionType {
  /// Uses the provided text exactly as it is.
  ///
  /// Example:
  /// `What is the output of this code?`
  raw,

  /// Resolves the text through the localization system using a translation key.
  ///
  /// Example:
  /// `levels.25.question`
  key,

  /// Treats the text as a code snippet that should be rendered using the
  /// application's code presentation UI.
  ///
  /// Example:
  /// `print("Hello, World!");`
  code;

  static QuestionType fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'RAW' => QuestionType.raw,
      'KEY' => QuestionType.key,
      'CODE' => QuestionType.code,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  String toDbValue() {
    return switch (this) {
      QuestionType.raw => 'RAW',
      QuestionType.key => 'KEY',
      QuestionType.code => 'CODE',
    };
  }
}
