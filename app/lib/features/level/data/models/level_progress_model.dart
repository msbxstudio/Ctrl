import 'package:ctrl/features/level.dart';

final class LevelProgressModel extends LevelProgress {
  const LevelProgressModel(
    super.id, {
    required super.createdAt,
    required super.attempts,
    super.ellapsedTime,
    required super.completed,
    required super.levelId,
  });

  factory LevelProgressModel.fromJson(Map<String, Object?> map) {
    return LevelProgressModel(
      map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      attempts: map['attempts'] as int,
      ellapsedTime: map['time_ms'] as int?,
      completed: (map['is_completed'] as int) == 1,
      levelId: map['level_id'] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'attempts': attempts,
      'time_ms': ellapsedTime,
      'is_completed': completed ? 1 : 0,
      'level_id': levelId,
    };
  }
}
