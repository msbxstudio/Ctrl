/// Available custom keyboard layouts.
enum LevelKeyboard {
  /// Symbols and punctuation.
  symbol,

  /// Numeric values.
  numeric,

  /// Characters used in hidden-word puzzles.
  hiddenWord,

  /// Boolean values (`true` / `false`).
  boolean,

  /// Complexity notation tokens.
  complexity;

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
