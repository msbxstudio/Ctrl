import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

/// Provides the state of the answer verification operation.
final checkAnswerMutationProvider =
    StateProvider.autoDispose<AsyncValue<bool?>>((_) => AsyncValue.data(null));

final levelControllerProvider = AsyncNotifierProvider.autoDispose.family(
  () => LevelController(),
);

final levelsControllerProvider = AsyncNotifierProvider.autoDispose(
  () => LevelsController(),
);

final levelRepositoryProvider = Provider.autoDispose<LevelRepository>((_) {
  return LevelRepositoryImpl(
    local: LocalLevelDatasourceImpl(DatabaseService.instance),
  );
});

final levelProgressRepositoryProvider =
    Provider.autoDispose<LevelProgressRepository>(
      (_) => LevelProgressRepositoryImpl(
        local: LocalLevelProgressDatasourceImpl(DatabaseService.instance),
      ),
    );
