import 'package:ctrl/features/player.dart';

final class PlayerModel {
  const new({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.lastActiveAt,
    required this.streakDays,
  });

  ///
  final int id;

  ///
  final DateTime createdAt;

  ///
  final DateTime? updatedAt;

  ///
  final DateTime? lastActiveAt;

  ///
  final String name;

  ///
  final int streakDays;

  factory fromMap(Map<String, Object?> map) {
    return PlayerModel(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      lastActiveAt: map['last_active_at'] != null
          ? DateTime.parse(map['last_active_at'] as String)
          : null,
      streakDays: map['streak_days'] as int,
    );
  }

  factory fromEntity(Player entity) {
    return PlayerModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastActiveAt: entity.lastActiveAt,
      streakDays: entity.streakDays,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'streak_days': streakDays,
    };
  }

  Player toEntity() {
    return Player(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastActiveAt: lastActiveAt,
      streakDays: streakDays,
    );
  }
}
