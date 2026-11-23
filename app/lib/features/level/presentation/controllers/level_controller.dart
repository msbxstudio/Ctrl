import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';
import 'package:msbx/exceptions.dart';

import 'package:ctrl/core/helpers.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

/// Controller for [LevelPage] view.
final class LevelController
    extends AutoDisposeFamilyAsyncNotifier<LevelState, int>
    implements Refreshable {
  @override
  Future<LevelState> build(int levelId) async {
    // Try to upsert level progress. If it doesn't exist, create it with default values.
    final progress = await ref
        .read(levelProgressRepositoryProvider)
        .getOne(LevelProgressByLevelId(levelId))
        .onError((e, _) {
          // If the error is a NotFoundException, it means the level progress doesn't exist,
          // so we create it with default values.
          if (e is! NotFoundException) throw e as Exception;

          return ref
              .read(levelProgressRepositoryProvider)
              .create(levelId: levelId, attempts: 0, ellapsedTime: 0);
        });

    final (level, player, count) = await Future.wait(
      [
        ref.read(levelRepositoryProvider).getOne(LevelById(levelId)),

        ref.read(playerRepositoryProvider).get(),
        ref.read(levelRepositoryProvider).count(),
      ],
      eagerError: true,
    ).then((r) => (r[0] as Level, r[1] as Player, r[2] as int));

    return LevelState(
      level: level,
      progress: progress,
      player: player,
      startTime: DateTime.now(),
      count: count,
    );
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Checks whether the provided answer matches the current level.
  Future<bool> checkAnswer(String answer) async {
    final mutation = ref.read(checkAnswerMutationProvider.notifier);

    mutation.state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final current = state.requireValue;

      final LevelState(:level, :progress, :player, :startTime, :count) =
          current;

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
              // currentLevelId: (match && level.id < count)
              //     ? level.id + 1
              //     : level.id,
            );

        state = AsyncData(
          current.copyWith(progress: updatedProgress, player: updatedPlayer),
        );
      }

      return match;
    });

    mutation.state = result;

    return result.valueOrNull ?? false;
  }
}
