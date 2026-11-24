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
        throw const NotFoundException('');
      }

      return result.toEntity();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('Failed to load level progress');
    }
  }

  @override
  Future<LevelProgress> create({
    required int levelId,
    required int attempts,
    required int ellapsedTime,
  }) async {
    try {
      final data = LevelProgress(
        id: 0,
        createdAt: DateTime.now(),
        attempts: attempts,
        ellapsedTime: ellapsedTime,
        completed: false,
        levelId: levelId,
        level: null,
      );

      await _local.save(LevelProgressModel.fromEntity(data));

      return data;
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
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

      throw const UnknownException('');
    }
  }

  @override
  Future<int> averageTime() async {
    try {
      // final result = await _service.query(
      //   'level_progresses',
      //   columns: ['AVG(time_ms) AS average_time'],
      // );

      // if (result.isEmpty) {
      //   throw const NotFoundException('No level progresses found');
      // }

      // final averageTime = result.first['average_time'] as double?;

      // return averageTime?.round() ?? 0;
      return await Future.value(0);
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }

  @override
  Future<int> count({bool? completed, bool? distinct}) async {
    try {
      // final result = await _service.query(
      //   'level_progresses',
      //   columns: ['COUNT(*) AS count'],
      //   where: completed != null ? 'is_completed = ?' : null,
      //   whereArgs: completed != null ? [completed ? 1 : 0] : null,
      //   distinct: distinct ?? false,
      // );

      // if (result.isEmpty) {
      //   throw const NotFoundException('No level progresses found');
      // }

      // final count = result.first['count'] as int?;

      // return count ?? 0;
      return await Future.value(0);
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }
}
