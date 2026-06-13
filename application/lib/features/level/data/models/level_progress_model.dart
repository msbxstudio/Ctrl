import 'package:ctrl/features/level/index.dart';

final class LevelProgressModel extends LevelProgress {
  const LevelProgressModel(
    super.id, {
    required super.createdAt,
    super.updatedAt,
    required super.attempts,
    super.ellapsedTime,
    required super.completed,
    required super.levelId,
  });

  factory LevelProgressModel.fromJson(Map<String, Object?> map) {
    return LevelProgressModel(
      map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      attempts: map['attempts'] as int,
      ellapsedTime: map['ellapsed_time'] as int?,
      completed: (map['completed'] as int) == 1,
      levelId: map['level_id'] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'attempts': attempts,
      'ellapsed_time': ellapsedTime,
      'completed': completed ? 1 : 0,
      'level_id': levelId,
    };
  }
}
