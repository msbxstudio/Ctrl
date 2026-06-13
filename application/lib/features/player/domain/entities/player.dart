import 'package:ctrl/features/level/index.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Player {
  final int id;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final DateTime? lastActiveAt;

  final String name;

  final int streakDays;

  final int currentLevelId;

  final Level? currentLevel;

  const Player(
    this.id, {
    required this.name,
    required this.createdAt,
    this.updatedAt,
    this.lastActiveAt,
    required this.streakDays,
    required this.currentLevelId,
    this.currentLevel,
  });
}
