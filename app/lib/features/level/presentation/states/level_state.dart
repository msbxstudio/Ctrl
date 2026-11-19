import 'package:msbx/msbx.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

final class const LevelState({
  required this.level,
  required this.progress,
  required this.player,
  required this.startTime,
  required this.count,
}) implements Copyable<LevelState> {
  final Level level;
  final LevelProgress progress;
  final Player player;
  final DateTime startTime;
  final int count;

  @override
  LevelState copyWith({
    Level? level,
    LevelProgress? progress,
    Player? player,
    DateTime? startTime,
    int? count,
  }) {
    return LevelState(
      level: level ?? this.level,
      progress: progress ?? this.progress,
      player: player ?? this.player,
      startTime: startTime ?? this.startTime,
      count: count ?? this.count,
    );
  }
}
