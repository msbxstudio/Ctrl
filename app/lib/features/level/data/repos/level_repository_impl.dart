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
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('errors.levels.load');
    }
  }

  @override
  Future<Level> getOne(LevelLookup lookup) async {
    try {
      final result = await switch (lookup) {
        LevelById(:final id) => _local.findById(id),
      };

      if (result == null) {
        throw const NotFoundException('errors.levels.missing');
      }

      return result.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('errors.levels.level_load');
    }
  }

  @override
  Future<Level?> getCurrent() async {
    try {
      final result = await _local.findCurrent();

      return result?.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('errors.levels.current');
    }
  }

  @override
  Future<int> getCount([
    LevelCountFilter filter = LevelCountFilter.all,
  ]) async {
    try {
      final result = await switch (filter) {
        LevelCountFilter.all => _local.countAll(),
        LevelCountFilter.completed => _local.countCompleted(),
        LevelCountFilter.pending => _local.countUncompleted(),
      };

      return result;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('errors.levels.count');
    }
  }
}
