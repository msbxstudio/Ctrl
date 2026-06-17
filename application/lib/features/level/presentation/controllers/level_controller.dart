import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/features/player/index.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [LevelPage] view.
final class LevelController
    extends AutoDisposeFamilyAsyncNotifier<LevelData, int> {
  @override
  Future<LevelData> build(int levelId) async {
    ref.invalidate(mainControllerProvider);

    final (level, progress) = await Future.wait([
      ref.read(levelRepositoryProvider).getOne(id: levelId),
      // Try to upsert level progress. If it doesn't exist, create it with default values.
      ref.read(levelProgressRepositoryProvider).getOne(levelId: levelId).onError((
        e,
        _,
      ) async {
        // If the error is a NotFoundException, it means the level progress doesn't exist,
        // so we create it with default values.
        if (e is! NotFoundException) {
          throw const UnhandledException('Failed to upsert level progress');
        }

        return await ref
            .read(levelProgressRepositoryProvider)
            .create(levelId: levelId, attempts: 0, ellapsedTime: 0);
      }),
      ref.read(playerRepositoryProvider).update(currentLevelId: levelId),
    ], eagerError: true).then((r) => (r[0] as Level, r[1] as LevelProgress));

    return (level: level, progress: progress, startTime: DateTime.now());
  }

  Future<bool> checkAnswer(String answer) async {
    final notifier = ref.read(checkAnswerMutationProvider.notifier);

    notifier.state = notifier.state.copyWith(
      isLoading: true,
      hasError: false,
      error: null,
    );

    try {
      if (state.valueOrNull == null) {
        throw const UnknownException('Level data is not available');
      }

      final (:level, :progress, :startTime) = state.value!;
      final match = level.answer == answer;

      if (!progress.completed) {
        final updatedProgress = await ref
            .read(levelProgressRepositoryProvider)
            .update(
              progress.id,
              attempts: progress.attempts + 1,
              ellapsedTime: match
                  ? DateTime.now().difference(startTime).inSeconds
                  : null,
              isCompleted: match,
            );

        state = AsyncValue.data((
          level: level,
          progress: updatedProgress,
          startTime: startTime,
        ));
      }

      notifier.state = notifier.state.copyWith(isLoading: false);
      return match;
    } catch (e) {
      notifier.state = notifier.state.copyWith(
        isLoading: false,
        hasError: true,
        error: e is AppException ? e.message : e.toString(),
      );
      return false;
    }
  }
}

typedef LevelData = ({Level level, LevelProgress progress, DateTime startTime});
