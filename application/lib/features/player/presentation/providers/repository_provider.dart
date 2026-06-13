import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/features/player/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerRepositoryProvider = Provider.autoDispose<PlayerRepository>((_) {
  return PlayerRepositoryImpl(DatabaseService.instance);
});
