import 'package:ctrl/core/services.dart';
import 'package:ctrl/core/types.dart';
import 'package:ctrl/features/player.dart';

final playerRepositoryProvider = RepositoryProvider<PlayerRepository>((_) {
  final datasource = LocalPlayerDataSourceImpl(DatabaseService.instance);

  return PlayerRepositoryImpl(datasource);
});
