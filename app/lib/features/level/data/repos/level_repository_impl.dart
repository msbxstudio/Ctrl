import 'package:msbx/exceptions.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LevelRepositoryImpl implements LevelRepository {
  ///
  const new(this._service);

  ///
  final DatabaseService _service;

  @override
  Future<List<Level>> getAll() async {
    try {
      final result = await _service.query('levels');

      return result.map(LevelModel.fromMap).toList();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to load level');
    }
  }

  @override
  Future<Level> getOne({required int id}) async {
    try {
      final result = await _service.query(
        'levels',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        throw const NotFoundException('Level not found');
      }

      return LevelModel.fromMap(result.first);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to load level');
    }
  }

  @override
  Future<Level?> getCurrent() async {
    try {
      final result = await DatabaseService.instance.query(
        'levels',
        where: '''
          NOT EXISTS (
            SELECT 1
            FROM level_progresses lp
            WHERE lp.level_id = levels.id
              AND lp.is_completed = 1
          )
        ''',
        orderBy: 'sort_order ASC, id ASC',
        limit: 1,
      );

      return result.firstOrNull != null
          ? LevelModel.fromMap(result.first)
          : null;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to load level');
    }
  }

  @override
  Future<int> count() async {
    try {
      final result = await _service.query('levels', columns: const ['id']);

      return result.length;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to count levels');
    }
  }
}
