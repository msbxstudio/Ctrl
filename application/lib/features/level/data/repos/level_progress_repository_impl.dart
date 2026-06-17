import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/level/index.dart';

final class LevelProgressRepositoryImpl implements LevelProgressRepository {
  final DatabaseService _service;

  const LevelProgressRepositoryImpl(this._service);

  @override
  Future<List<LevelProgress>> getAll() async {
    try {
      final result = await _service.query('level_progress');
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
        'level_progress',
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
      final id = await _service.insert('level_progress', {
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
        'level_progress',
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
}
