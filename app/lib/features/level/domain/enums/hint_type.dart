/// Enum that represents the type of hint.
enum HintType {
  /// A hint that is a raw text.
  raw,

  /// A hint that is a translation key.
  key;

  static HintType fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'RAW' => HintType.raw,
      'KEY' => HintType.key,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  String toDbValue() {
    return switch (this) {
      HintType.raw => 'RAW',
      HintType.key => 'KEY',
    };
  }
}
