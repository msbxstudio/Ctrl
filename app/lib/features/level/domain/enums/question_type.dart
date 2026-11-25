/// Defines how the content of a level question is interpreted
/// and presented to the player.
enum QuestionType {
  /// Literal text displayed without localization.
  raw,

  /// A localization key resolved through the translation system.
  key,

  /// Source code rendered through the application's code presentation UI.
  code;

  /// Converts a database [value] into its corresponding question type.
  ///
  /// The conversion is case-insensitive.
  ///
  /// Throws an [ArgumentError] if [value] is not recognized.
  static QuestionType fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'RAW' => QuestionType.raw,
      'KEY' => QuestionType.key,
      'CODE' => QuestionType.code,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  /// Returns the canonical database representation of this question type.
  String toDbValue() {
    return switch (this) {
      QuestionType.raw => 'RAW',
      QuestionType.key => 'KEY',
      QuestionType.code => 'CODE',
    };
  }
}
