import 'package:ctrl/features/level.dart';

/// Represents the state of the level collection and the player's progression.
final class LevelsState {
  /// Creates a state containing the available levels and the current level,
  /// if any.
  const new({
    required this.levels,
    required this.currentLevel,
  });

  /// The collection of levels available to the player.
  final List<Level> levels;

  /// The current level within the player's progression.
  ///
  /// A `null` value indicates that no current level is available.
  final Level? currentLevel;
}
