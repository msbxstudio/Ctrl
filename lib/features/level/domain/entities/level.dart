import 'package:flutter/foundation.dart';

@immutable
abstract class Level {
  final int id;
  final LevelType type;
  final LevelKeyboard keyboard;
  final String question;
  final String answer;
  final List<String> options;

  const Level(
    this.id, {
    required this.type,
    required this.keyboard,
    required this.question,
    required this.answer,
    required this.options,
  });
}

/// Defines the type of level, which can be used to categorize levels and determine their behavior.
enum LevelType {
  /// A level that requires the player to input a command or answer based on a question.
  outputPrediction,

  /// A level that requires the player to identify a missing symbol in a command or code snippet.
  missingSymbol,

  /// A level that involves debugging a piece of code or identifying errors.
  debug,

  /// A level that requires logical reasoning to solve a problem or answer a question.
  logic,

  /// A level that involves uncovering hidden commands or features.
  hiddenCommand,

  /// A level that requires the player to use a specific keyboard layout to input their answer.
  complexity,
}

/// Defines the type of keyboard layout to be used for a level.
enum LevelKeyboard {
  /// A keyboard layout that includes only numeric keys (0-9).
  numeric,

  /// A keyboard layout that includes symbols and special characters.
  symbol,

  /// A keyboard layout that includes alphabetic characters (A-Z).
  character,

  /// A keyboard layout that includes complex keys and combinations.
  complexity,
}
