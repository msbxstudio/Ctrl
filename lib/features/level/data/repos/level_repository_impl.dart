import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/features/level/index.dart';

final class LevelRepositoryImpl implements LevelRepository {
  final DatabaseService _service;

  const LevelRepositoryImpl(this._service);

  @override
  Future<List<Level>> getAll() async {
    try {
      final result = await _service.query('level');
      final levels = result.map(LevelModel.fromJson).toList();

      return levels;
    } catch (e) {
      throw const UnknownException('Failed to load levels');
    }
  }

  @override
  Future<Level> getOne({required int id}) async {
    try {
      final result = await _service.query(
        'level',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        throw const NotFoundException('Level not found');
      }

      final level = LevelModel.fromJson(result.first);

      return level;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to load level');
    }
  }
}
