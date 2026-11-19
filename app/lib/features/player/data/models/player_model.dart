import 'package:ctrl/features/player.dart';

final class PlayerModel extends Player {
  const PlayerModel(
    super.id, {
    required super.name,
    required super.createdAt,
    super.updatedAt,
    super.lastActiveAt,
    required super.streakDays,
    required super.currentLevelId,
    super.currentLevel,
  });

  factory PlayerModel.fromJson(Map<String, Object?> map) {
    return PlayerModel(
      map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      lastActiveAt: map['last_active_at'] != null
          ? DateTime.parse(map['last_active_at'] as String)
          : null,
      streakDays: map['streak_days'] as int,
      currentLevelId: map['current_level_id'] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'streak_days': streakDays,
      'current_level_id': currentLevelId,
    };
  }
}
