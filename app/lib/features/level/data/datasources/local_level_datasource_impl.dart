import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LocalLevelDataSourceImpl implements LocalLevelDataSource {
  const new(this._database);

  final DatabaseService _database;

  @override
  Future<List<LevelModel>> findAll() async {
    final result = await _database.query('levels');

    return result.map(LevelModel.fromMap).toList();
  }

  @override
  Future<LevelModel?> findById(int id) async {
    final result = await _database.query(
      'levels',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.singleOrNull != null
        ? LevelModel.fromMap(result.single)
        : null;
  }

  @override
  Future<LevelModel?> findCurrent() async {
    final result = await _database.query(
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

    return result.singleOrNull != null
        ? LevelModel.fromMap(result.single)
        : null;
  }

  @override
  Future<int> countAll() async {
    final result = await _database.query(
      'levels',
      columns: ['COUNT(*) AS total'],
    );

    return result.first['total'] as int;
  }

  @override
  Future<int> countCompleted() async {
    final result = await _database.query(
      'level_progresses',
      columns: ['COUNT(*) AS total'],
      where: 'is_completed = ?',
      whereArgs: [1],
    );

    return result.first['total'] as int;
  }

  @override
  Future<int> countUncompleted() async {
    final result = await _database.query(
      'levels',
      columns: ['COUNT(*) AS total'],
      where: '''
      NOT EXISTS (
        SELECT 1
        FROM level_progresses
        WHERE level_id = levels.id
          AND is_completed = ?
      )
    ''',
      whereArgs: [1],
    );

    return result.first['total'] as int;
  }

  @override
  Future<void> save(LevelModel model) async {
    final data = model.toMap()..remove('id');

    await _database.update(
      'levels',
      data,
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
