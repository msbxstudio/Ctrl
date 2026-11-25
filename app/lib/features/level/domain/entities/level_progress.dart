import 'package:ctrl/features/level.dart';

/// Represents a player's progress within a specific level.
///
/// Tracks attempts, elapsed time, and completion status.
final class LevelProgress {
  /// Creates a progress record associated with [levelId].
  ///
  /// The associated [level] may be absent.
  const new({
    required this.id,
    required this.createdAt,
    required this.attempts,
    required this.ellapsedTime,
    required this.completed,
    required this.levelId,
    required this.level,
  });

  /// Uniquely identifies the progress record.
  final int id;

  /// Records when the progress entry was created.
  final DateTime createdAt;

  /// The number of attempts made to solve the level.
  final int attempts;

  /// The elapsed time recorded for the level, if available.
  final int? ellapsedTime;

  /// Whether the player has successfully completed the level.
  final bool completed;

  /// Identifies the level associated with this progress record.
  final int levelId;

  /// The associated level, if available.
  final Level? level;
}
