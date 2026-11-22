import 'package:msbx/exceptions.dart';
import 'package:msbx/utils.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LevelProgressRepositoryImpl implements LevelProgressRepository {
  const new(this._service);

  final DatabaseService _service;

  @override
  Future<List<LevelProgress>> getAll() async {
    try {
      final result = await _service.query('level_progresses');
      final progress = result.map(LevelProgressModel.fromJson).toList();

      return progress;
    } catch (e) {
      throw const UnknownException('Failed to load level progress');
    }
  }

  @override
  Future<LevelProgress> getOne({int? id, int? levelId}) async {
    Debugger.ensure(
      id != null || levelId != null,
      'Either id or levelId must be provided',
    );

    try {
      final result = await _service.query(
        'level_progresses',
        where: 'id = ? OR level_id = ?',
        whereArgs: [id, levelId],
      );

      if (result.isEmpty) {
        throw const NotFoundException('Level progress not found');
      }

      final progress = LevelProgressModel.fromJson(result.first);

      return progress;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

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
      final id = await _service.insert('level_progresses', {
        'level_id': levelId,
        'attempts': attempts,
        'time_ms': ellapsedTime,
        'is_completed': 0,
      });

      return await getOne(id: id);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to create level progress');
    }
  }

  @override
  Future<LevelProgress> update(
    int id, {
    int? attempts,
    int? ellapsedTime,
    bool? isCompleted,
  }) async {
    final data = <String, Object?>{};

    try {
      if (attempts != null) {
        data['attempts'] = attempts;
      }

      if (ellapsedTime != null) {
        data['time_ms'] = ellapsedTime;
      }

      if (isCompleted != null) {
        data['is_completed'] = isCompleted ? 1 : 0;
      }

      if (data.isEmpty) return await getOne(id: id);

      await _service.update(
        'level_progresses',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );

      return await getOne(id: id);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to update level progress');
    }
  }

  @override
  Future<int> averageTime() async {
    try {
      final result = await _service.query(
        'level_progresses',
        columns: ['AVG(time_ms) AS average_time'],
      );

      if (result.isEmpty) {
        throw const NotFoundException('No level progresses found');
      }

      final averageTime = result.first['average_time'] as double?;

      return averageTime?.round() ?? 0;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to calculate average time');
    }
  }

  @override
  Future<int> count({bool? completed, bool? distinct}) async {
    try {
      final result = await _service.query(
        'level_progresses',
        columns: ['COUNT(*) AS count'],
        where: completed != null ? 'is_completed = ?' : null,
        whereArgs: completed != null ? [completed ? 1 : 0] : null,
        distinct: distinct ?? false,
      );

      if (result.isEmpty) {
        throw const NotFoundException('No level progresses found');
      }

      final count = result.first['count'] as int?;

      return count ?? 0;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to count level progresses');
    }
  }
}
