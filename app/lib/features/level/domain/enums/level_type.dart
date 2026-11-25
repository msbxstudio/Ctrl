/// Defines the puzzle categories available within the game.
///
/// Each category identifies the nature of the challenge presented
/// to the player, independently of its input mechanism.
enum LevelType {
  /// Challenges the player to identify or repair a syntax error.
  syntax,

  /// Challenges the player to determine the output of a code snippet.
  outputPrediction,

  /// Challenges the player's programming and logical reasoning skills.
  logic,

  /// Challenges the player to discover a hidden word or command.
  hiddenWord,

  /// Challenges the player to determine the complexity of an algorithm.
  complexity;

  /// Converts a database [value] into its corresponding level type.
  ///
  /// The conversion is case-insensitive.
  ///
  /// Throws an [ArgumentError] if [value] is not recognized.
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

  /// Returns the canonical database representation of this level type.
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
