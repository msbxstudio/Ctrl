import 'package:msbx/exceptions.dart';

import 'package:ctrl/features/level.dart';

final class LevelRepositoryImpl implements LevelRepository {
  ///
  const new(this._local);

  final LocalLevelDataSource _local;

  @override
  Future<List<Level>> getAll() async {
    try {
      final result = await _local.findAll();

      return result.map((e) => e.toEntity()).toList();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }

  @override
  Future<Level> getOne(LevelLookup lookup) async {
    try {
      final result = await switch (lookup) {
        LevelById(:final id) => _local.findById(id),
      };

      if (result == null) {
        throw const NotFoundException('');
      }

      return result.toEntity();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }

  @override
  Future<Level?> getCurrent() async {
    try {
      final result = await _local.findCurrent();

      return result?.toEntity();
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }

  @override
  Future<int> count() async {
    try {
      final result = await _local.count();

      return result;
    } catch (e) {
      if (e is AppException) rethrow;

      throw const UnknownException('');
    }
  }
}
