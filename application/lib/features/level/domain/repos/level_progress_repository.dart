import 'package:ctrl/features/level/index.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract interface class LevelProgressRepository {
  Future<List<LevelProgress>> getAll();

  Future<LevelProgress> getOne({int? id, int? levelId});

  Future<LevelProgress> create({
    required int levelId,
    required int attempts,
    required int ellapsedTime,
  });

  Future<LevelProgress> update(
    int id, {
    int? attempts,
    int? ellapsedTime,
    bool? isCompleted,
  });

  Future<int> averageTime();

  Future<int> count({bool? completed, bool? distinct});
}
