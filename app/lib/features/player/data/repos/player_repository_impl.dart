import 'package:msbx/exceptions.dart';

import 'package:ctrl/features/player.dart';

final class PlayerRepositoryImpl implements PlayerRepository {
  const new(this._local);

  final LocalPlayerDataSource _local;

  @override
  Future<Player> get() async {
    try {
      final result = await _local.get();

      if (result == null) {
        throw UnsupportedError('Player not found');
      }

      return result.toEntity();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to get player');
    }
  }

  @override
  Future<Player> update({
    String? name,
    DateTime? lastActiveAt,
    int? streakDays,
  }) async {
    try {
      final current = await get();

      final updated = Player(
        id: current.id,
        name: name ?? current.name,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
        lastActiveAt: lastActiveAt ?? current.lastActiveAt,
        streakDays: streakDays ?? current.streakDays,
      );

      await _local.save(PlayerModel.fromEntity(updated));

      return updated;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to update player');
    }
  }
}
