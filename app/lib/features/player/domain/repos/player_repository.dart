import 'package:ctrl/features/player.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract interface class PlayerRepository {
  Future<Player> get();

  Future<Player> update({
    String? name,
    DateTime? lastActiveAt,
    int? streakDays,
  });
}
