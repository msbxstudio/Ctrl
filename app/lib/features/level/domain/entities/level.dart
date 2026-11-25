import 'package:ctrl/features/level.dart';

/// Represents a playable puzzle within the game.
///
/// Defines the challenge, input mechanism, expected answer, and position
/// within the level progression.
final class Level {
  /// Creates a level with its challenge content and input configuration.
  ///
  /// The [options] and [answer] must be consistent with the selected
  /// [keyboard]. The [hint] and [progresses] may be absent.
  const new({
    required this.id,
    required this.type,
    required this.keyboard,
    required this.question,
    required this.answer,
    required this.sortOrder,
    required this.hint,
    required this.options,
    required this.progresses,
  });

  /// Uniquely identifies the level.
  final int id;

  /// Defines the category of challenge presented to the player.
  final LevelType type;

  /// Defines the input mechanism used to construct an answer.
  final LevelKeyboard keyboard;

  /// Contains the challenge presented to the player.
  final Question question;

  /// The expected answer used to evaluate the player's submission.
  final String answer;

  /// Determines the level's position within the ordered progression.
  final int sortOrder;

  /// Provides optional assistance for solving the challenge.
  final Hint? hint;

  /// The input options available for constructing an answer.
  final List<String> options;

  /// The progress records associated with this level, if available.
  final List<LevelProgress>? progresses;
}
