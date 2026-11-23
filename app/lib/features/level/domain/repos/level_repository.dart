import 'package:ctrl/features/level.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract interface class LevelRepository {
  Future<List<Level>> getAll();

  Future<Level> getOne(LevelLookup lookup);

  Future<Level?> getCurrent();

  Future<int> count();
}
