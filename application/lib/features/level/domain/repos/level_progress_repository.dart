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

  Future<LevelProgress> update(String id, {int? attempts, int? ellapsedTime});
}
