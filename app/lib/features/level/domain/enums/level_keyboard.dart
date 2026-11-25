/// Defines the custom keyboard layouts available for constructing
/// answers within a level.
enum LevelKeyboard {
  /// Provides symbols and punctuation characters.
  symbol,

  /// Provides numeric input tokens.
  numeric,

  /// Provides characters for constructing hidden words or commands.
  hiddenWord,

  /// Provides boolean input tokens (`true` and `false`).
  boolean,

  /// Provides tokens representing algorithmic complexity notation.
  complexity;

  /// Converts a database [value] into its corresponding keyboard layout.
  ///
  /// The conversion is case-insensitive.
  ///
  /// Throws an [ArgumentError] if [value] is not recognized.
  static LevelKeyboard fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'SYMBOL' => LevelKeyboard.symbol,
      'NUMERIC' => LevelKeyboard.numeric,
      'HIDDEN_WORD' => LevelKeyboard.hiddenWord,
      'BOOLEAN' => LevelKeyboard.boolean,
      'COMPLEXITY' => LevelKeyboard.complexity,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  /// Returns the canonical database representation of this keyboard layout.
  String toDbValue() {
    return switch (this) {
      LevelKeyboard.symbol => 'SYMBOL',
      LevelKeyboard.numeric => 'NUMERIC',
      LevelKeyboard.hiddenWord => 'HIDDEN_WORD',
      LevelKeyboard.boolean => 'BOOLEAN',
      LevelKeyboard.complexity => 'COMPLEXITY',
    };
  }
}
