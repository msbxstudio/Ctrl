import 'package:ctrl/features/player.dart';

abstract interface class LocalPlayerDataSource {
  Future<PlayerModel?> get();

  Future<void> save(PlayerModel model);
}
