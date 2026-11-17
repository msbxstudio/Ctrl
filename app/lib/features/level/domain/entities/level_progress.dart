import 'package:flutter/foundation.dart';

@immutable
abstract class LevelProgress {
  final int id;
  final DateTime createdAt;
  final int attempts;
  final int? ellapsedTime;
  final bool completed;
  final int levelId;

  const LevelProgress(
    this.id, {
    required this.createdAt,
    required this.attempts,
    this.ellapsedTime,
    required this.completed,
    required this.levelId,
  });
}
