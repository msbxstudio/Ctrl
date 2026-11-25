import 'package:msbx/exceptions.dart';

import 'package:ctrl/features/level.dart';

final class LevelProgressRepositoryImpl implements LevelProgressRepository {
  const new(this._local);

  final LocalLevelProgressDataSource _local;

  @override
  Future<LevelProgress> getOne(LevelProgressLookup lookup) async {
    try {
      final result = await switch (lookup) {
        LevelProgressById(:final id) => _local.findById(id),
        LevelProgressByLevelId(:final levelId) => _local.findByLevelId(levelId),
      };

      if (result == null) {
        throw const NotFoundException('errors.progress.missing');
      }

      return result.toEntity();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('errors.progress.load');
    }
  }

  @override
  Future<LevelProgress> create({
    required int levelId,
    required int attempts,
    required int ellapsedTime,
  }) async {
    try {
      final data = LevelProgressModel(
        id: 0,
        createdAt: DateTime.now(),
        attempts: attempts,
        ellapsedTime: ellapsedTime,
        completed: false,
        levelId: levelId,
        level: null,
      );

      final created = await _local.create(data);

      return created.toEntity();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('errors.progress.create');
    }
  }

  @override
  Future<LevelProgress> update(
    int id, {
    int? attempts,
    int? ellapsedTime,
    bool? isCompleted,
  }) async {
    try {
      final current = await getOne(LevelProgressById(id));

      final updated = LevelProgress(
        id: id,
        createdAt: current.createdAt,
        attempts: attempts ?? current.attempts,
        ellapsedTime: ellapsedTime ?? current.ellapsedTime,
        completed: isCompleted ?? current.completed,
        levelId: current.levelId,
        level: current.level,
      );

      await _local.save(LevelProgressModel.fromEntity(updated));

      return updated;
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('errors.progress.save');
    }
  }

  @override
  Future<int> averageTime() async {
    try {
      return await _local.averageTime();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('errors.progress.stats');
    }
  }
}
