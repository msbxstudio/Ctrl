import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/features/player/index.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [LevelPage] view.
final class LevelController
    extends AutoDisposeFamilyAsyncNotifier<LevelData, int> {
  @override
  Future<LevelData> build(int levelId) async {
    ref.invalidate(mainControllerProvider);

    final (
      level,
      progress,
      player,
      count,
    ) = await Future.wait([
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
      ref.read(playerRepositoryProvider).get(),
      ref.read(levelRepositoryProvider).count(),
    ], eagerError: true).then(
      (r) =>
          (r[0] as Level, r[1] as LevelProgress, r[2] as Player, r[3] as int),
    );

    return (
      level: level,
      progress: progress,
      player: player,
      startTime: DateTime.now(),
      count: count,
    );
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

      final (:level, :progress, :player, :startTime, :count) = state.value!;
      final match = level.answer == answer;

      if (!progress.completed) {
        final updatedProgress = await ref
            .read(levelProgressRepositoryProvider)
            .update(
              progress.id,
              attempts: progress.attempts + 1,
              ellapsedTime: match
                  ? DateTime.now().difference(startTime).inMilliseconds
                  : null,
              isCompleted: match,
            );

        final updatedPlayer = await ref
            .read(playerRepositoryProvider)
            .update(
              lastActiveAt: match ? DateTime.now() : null,
              streakDays: match
                  ? calculateStreak(player.streakDays, player.lastActiveAt)
                  : null,
              currentLevelId: (match && level.id < count)
                  ? level.id + 1
                  : level.id,
            );

        state = AsyncValue.data((
          level: level,
          progress: updatedProgress,
          player: updatedPlayer,
          startTime: startTime,
          count: count,
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

typedef LevelData = ({
  Level level,
  LevelProgress progress,
  Player player,
  DateTime startTime,
  int count,
});
