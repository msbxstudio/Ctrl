import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/player.dart';

final class LocalPlayerDataSourceImpl implements LocalPlayerDataSource {
  ///
  const new(this._database);

  ///
  final DatabaseService _database;

  @override
  Future<PlayerModel?> get() async {
    final result = await _database.query(
      'players',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    return result.singleOrNull != null
        ? PlayerModel.fromMap(result.single)
        : null;
  }

  @override
  Future<void> save(PlayerModel model) async {
    final data = model.toMap()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');

    await _database.update(
      'players',
      {...data, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
