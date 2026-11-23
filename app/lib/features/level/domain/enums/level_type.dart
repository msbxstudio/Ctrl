/// Available puzzle categories.
enum LevelType {
  /// Find or repair a syntax error.
  syntax,

  /// Predict the output of a code snippet.
  outputPrediction,

  /// Solve a programming logic challenge.
  logic,

  /// Discover a hidden word or command.
  hiddenWord,

  /// Analyze algorithm complexity.
  complexity;

  static LevelType fromDbValue(String value) {
    return switch (value.toUpperCase()) {
      'SYNTAX' => LevelType.syntax,
      'OUTPUT_PREDICTION' => LevelType.outputPrediction,
      'LOGIC' => LevelType.logic,
      'HIDDEN_WORD' => LevelType.hiddenWord,
      'COMPLEXITY' => LevelType.complexity,
      _ => throw ArgumentError.value(value, ''),
    };
  }

  String toDbValue() {
    return switch (this) {
      LevelType.syntax => 'SYNTAX',
      LevelType.outputPrediction => 'OUTPUT_PREDICTION',
      LevelType.logic => 'LOGIC',
      LevelType.hiddenWord => 'HIDDEN_WORD',
      LevelType.complexity => 'COMPLEXITY',
    };
  }
}
