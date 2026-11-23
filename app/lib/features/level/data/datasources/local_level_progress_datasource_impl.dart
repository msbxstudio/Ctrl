import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

final class LocalLevelProgressDatasourceImpl
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
  Future<void> save(LevelProgressModel model) async {
    final data = model.toMap()..remove('id');

    await _database.update(
      'level_progresses',
      data,
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
