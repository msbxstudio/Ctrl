import 'package:ctrl/features/level.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Level {
  final int id;

  final LevelType type;

  final LevelKeyboard keyboard;

  final LevelQuestion question;

  final String answer;

  final LevelHint? hint;

  final List<String> options;

  final LevelProgress? progress;

  const Level(
    this.id, {
    required this.type,
    required this.keyboard,
    required this.question,
    required this.answer,
    this.hint,
    required this.options,
    this.progress,
  });
}

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
  complexity,
}

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
  complexity,
}
