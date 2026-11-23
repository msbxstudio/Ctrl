import 'package:ctrl/features/level.dart';

abstract interface class LocalLevelDataSource {
  Future<List<LevelModel>> findAll();

  Future<LevelModel?> findById(int id);

  Future<LevelModel?> findCurrent();

  Future<int> count();

  Future<void> save(LevelModel model);
}
