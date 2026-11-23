import 'package:ctrl/features/level.dart';

abstract interface class LocalLevelProgressDataSource {
  Future<LevelProgressModel?> findById(int id);

  Future<LevelProgressModel?> findByLevelId(int levelId);

  Future<void> save(LevelProgressModel model);
}
