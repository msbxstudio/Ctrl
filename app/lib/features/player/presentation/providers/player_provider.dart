import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerRepositoryProvider = Provider.autoDispose<PlayerRepository>(
  (_) => PlayerRepositoryImpl(
    local: LocalPlayerDataSourceImpl(DatabaseService.instance),
  ),
);
