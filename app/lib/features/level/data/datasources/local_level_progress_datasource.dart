import 'package:ctrl/features/level.dart';

abstract interface class LocalLevelProgressDataSource {
  Future<LevelProgressModel?> findById(int id);

  Future<LevelProgressModel?> findByLevelId(int levelId);

  /// Inserts progress or returns the existing record for the same level.
  Future<LevelProgressModel> create(LevelProgressModel model);

  /// Updates existing progress, throwing if the record no longer exists.
  Future<void> save(LevelProgressModel model);

  /// Returns the rounded average completion time in milliseconds, or zero.
  Future<int> averageTime();
}
