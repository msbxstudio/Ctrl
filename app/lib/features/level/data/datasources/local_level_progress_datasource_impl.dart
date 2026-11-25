import 'package:msbx/exceptions.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LocalLevelProgressDataSourceImpl
    implements LocalLevelProgressDataSource {
  ///
  const new(this._database);

  ///
  final DatabaseService _database;

  @override
  Future<LevelProgressModel?> findById(int id) async {
    final result = await _database.query(
      'level_progresses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.singleOrNull != null
        ? LevelProgressModel.fromMap(result.single)
        : null;
  }

  @override
  Future<LevelProgressModel?> findByLevelId(int levelId) async {
    final result = await _database.query(
      'level_progresses',
      where: 'level_id = ?',
      whereArgs: [levelId],
      limit: 1,
    );

    return result.singleOrNull != null
        ? LevelProgressModel.fromMap(result.single)
        : null;
  }

  @override
  Future<LevelProgressModel> create(LevelProgressModel model) {
    return _database.service.transaction((txn) async {
      final existing = await txn.query(
        'level_progresses',
        where: 'level_id = ?',
        whereArgs: [model.levelId],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        return LevelProgressModel.fromMap(existing.single);
      }

      final data = model.toMap()..remove('id');
      final id = await txn.insert('level_progresses', data);

      return LevelProgressModel.fromMap({...data, 'id': id});
    });
  }

  @override
  Future<void> save(LevelProgressModel model) async {
    final data = model.toMap()..remove('id');

    final updated = await _database.update(
      'level_progresses',
      data,
      where: 'id = ?',
      whereArgs: [model.id],
    );

    if (updated == 0) {
      throw const NotFoundException('errors.progress.missing');
    }
  }

  @override
  Future<int> averageTime() async {
    final result = await _database.query(
      'level_progresses',
      columns: ['AVG(time_ms) AS average_time'],
      where: 'is_completed = ?',
      whereArgs: [1],
    );

    // SQLite excludes NULL times and returns NULL when no times are available.
    return (result.single['average_time'] as num?)?.round() ?? 0;
  }
}
