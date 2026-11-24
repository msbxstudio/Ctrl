import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/core/types.dart';
import 'package:ctrl/features/level.dart';

/// Provides the state of the answer verification operation.
final checkAnswerMutationProvider = MutationProvider<bool?>((_) {
  return AsyncValue.data(null);
});

final levelControllerProvider = ControllerFamilyProvider(() {
  return LevelController();
});

final levelsControllerProvider = ControllerProvider(() {
  return LevelsController();
});

final levelRepositoryProvider = RepositoryProvider<LevelRepository>((_) {
  final datasource = LocalLevelDataSourceImpl(DatabaseService.instance);

  return LevelRepositoryImpl(datasource);
});

final levelProgressRepositoryProvider =
    RepositoryProvider<LevelProgressRepository>((_) {
      final datasource = LocalLevelProgressDataSourceImpl(
        DatabaseService.instance,
      );

      return LevelProgressRepositoryImpl(datasource);
    });
