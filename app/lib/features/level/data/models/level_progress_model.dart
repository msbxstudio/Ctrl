import 'package:ctrl/features/level.dart';

final class LevelProgressModel {
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

  factory LevelProgressModel.fromMap(Map<String, dynamic> map) {
    return LevelProgressModel(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      attempts: map['attempts'] as int,
      ellapsedTime: map['time_ms'] as int?,
      completed: (map['is_completed'] as int) == 1,
      levelId: map['level_id'] as int,
      level: null,
    );
  }

  factory LevelProgressModel.fromEntity(LevelProgress entity) {
    return LevelProgressModel(
      id: entity.id,
      createdAt: entity.createdAt,
      attempts: entity.attempts,
      ellapsedTime: entity.ellapsedTime,
      completed: entity.completed,
      levelId: entity.levelId,
      level: entity.level,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'attempts': attempts,
      'time_ms': ellapsedTime,
      'is_completed': completed ? 1 : 0,
      'level_id': levelId,
    };
  }

  LevelProgress toEntity() {
    return LevelProgress(
      id: id,
      createdAt: createdAt,
      attempts: attempts,
      ellapsedTime: ellapsedTime,
      completed: completed,
      levelId: levelId,
      level: level,
    );
  }
}
