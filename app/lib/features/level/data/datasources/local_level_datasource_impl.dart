import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LocalLevelDatasourceImpl implements LocalLevelDataSource {
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
  Future<int> count() async {
    final result = await _database.query('levels', columns: ['id']);

    return result.length;
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
