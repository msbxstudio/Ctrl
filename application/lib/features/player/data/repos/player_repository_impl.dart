import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/features/player/index.dart';

final class PlayerRepositoryImpl implements PlayerRepository {
  final DatabaseService _service;

  const PlayerRepositoryImpl(this._service);

  @override
  Future<Player> get() async {
    try {
      final result = await _service.query(
        'player',
        where: 'id = ?',
        whereArgs: [1],
      );

      if (result.isEmpty) {
        throw const NotFoundException('Player not found');
      }

      final player = PlayerModel.fromJson(result.first);

      return player;
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
    int? currentLevelId,
  }) async {
    final data = <String, Object?>{};

    try {
      if (name != null) {
        data['name'] = name;
      }

      if (lastActiveAt != null) {
        data['last_active_at'] = lastActiveAt.toIso8601String();
      }

      if (streakDays != null) {
        data['streak_days'] = streakDays;
      }

      if (currentLevelId != null) {
        data['current_level_id'] = currentLevelId;
      }

      if (data.isEmpty) return await get();

      await _service.update('player', data, where: 'id = ?', whereArgs: [1]);

      return await get();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const UnknownException('Failed to update player');
    }
  }
}
