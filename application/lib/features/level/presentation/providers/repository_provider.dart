import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelRepositoryProvider = Provider.autoDispose<LevelRepository>((_) {
  return LevelRepositoryImpl(DatabaseService.instance);
});

final levelProgressRepositoryProvider =
    Provider.autoDispose<LevelProgressRepository>((_) {
      return LevelProgressRepositoryImpl(DatabaseService.instance);
    });
