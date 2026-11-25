import 'package:msbx/contracts.dart';

import 'package:ctrl/features/level.dart';

/// Represents the state of an active level session.
///
/// Aggregates the current level, its progress, the player, and session metadata.
final class LevelState implements Copyable<LevelState> {
  /// Creates a state for a level session.
  ///
  /// The supplied [progress] must correspond to [level], and [startTime]
  /// represents the beginning of the session.
  const new({
    required this.level,
    required this.progress,
    required this.startTime,
    required this.count,
  });

  /// The level currently presented to the player.
  final Level level;

  /// The player's progress associated with [level].
  final LevelProgress progress;

  /// The timestamp marking the beginning of the level session.
  final DateTime startTime;

  /// The total number of available levels.
  final int count;

  /// Returns a copy of this state with the specified values replaced.
  ///
  /// Omitted or `null` arguments retain their existing values.
  @override
  LevelState copyWith({
    Level? level,
    LevelProgress? progress,
    DateTime? startTime,
    int? count,
  }) {
    return LevelState(
      level: level ?? this.level,
      progress: progress ?? this.progress,
      startTime: startTime ?? this.startTime,
      count: count ?? this.count,
    );
  }
}
