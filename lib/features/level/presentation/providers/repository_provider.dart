import 'package:ctrl/features/level/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelRepositoryProvider = Provider.autoDispose<LevelRepository>((_) {
  return LevelRepositoryImpl();
});
