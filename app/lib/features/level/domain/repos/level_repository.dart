import 'package:ctrl/features/level/index.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract interface class LevelRepository {
  Future<List<Level>> getAll();

  Future<Level> getOne({required int id});

  Future<int> count();
}
