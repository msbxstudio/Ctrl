import 'package:ctrl/features/level/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelControllerProvider = AsyncNotifierProvider.autoDispose.family(() {
  return LevelController();
});

final levelsControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return LevelsController();
});
