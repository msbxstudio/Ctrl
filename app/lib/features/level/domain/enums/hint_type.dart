/// Defines how the content of a level hint is interpreted.
enum HintType {
  /// Literal text displayed without localization.
  raw,

  /// A localization key resolved through the translation system.
  key;

  /// Converts a database [value] into its corresponding hint type.
  ///
  /// The conversion is case-insensitive.
  ///
  /// Throws an [ArgumentError] if [value] is not recognized.
  static HintType fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'RAW' => HintType.raw,
      'KEY' => HintType.key,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  /// Returns the canonical database representation of this hint type.
  String toDbValue() {
    return switch (this) {
      HintType.raw => 'RAW',
      HintType.key => 'KEY',
    };
  }
}
