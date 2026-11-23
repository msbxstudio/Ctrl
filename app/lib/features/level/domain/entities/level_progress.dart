import 'package:ctrl/features/level.dart';

final class LevelProgress {
  const new({
    required this.id,
    required this.createdAt,
    required this.attempts,
    required this.ellapsedTime,
    required this.completed,
    required this.levelId,
    required this.level,
  });

  final int id;

  final DateTime createdAt;

  final int attempts;

  final int? ellapsedTime;

  final bool completed;

  final int levelId;

  final Level? level;
}
