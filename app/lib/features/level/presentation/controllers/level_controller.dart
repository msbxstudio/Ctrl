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

    final (count, level) =
        await Future.wait(
          [
            /// ...
            ref.read(levelRepositoryProvider).getCount(),

            /// ...
            ref.read(levelRepositoryProvider).getOne(LevelById(levelId)),
          ],

          eagerError: true,
        ).then((r) {
          return (
            r[0] as int,
            r[1] as Level,
          );
        });

    return LevelState(
      count: count,
      level: level,
      progress: progress,

      startTime: DateTime.now(),
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

      final LevelState(
        :level,
        progress: currentProgress,
        :startTime,
        :count,
      ) = current;

      final match = level.answer == answer;

      if (!currentProgress.completed) {
        final (player, updatedProgress) =
            await Future.wait(
              [
                /// ...
                ref.read(playerRepositoryProvider).get(),

                /// ...
                ref
                    .read(levelProgressRepositoryProvider)
                    .update(
                      currentProgress.id,
                      attempts: currentProgress.attempts + 1,
                      ellapsedTime: match
                          ? DateTime.now().difference(startTime).inMilliseconds
                          : null,
                      isCompleted: match,
                    ),
              ],

              eagerError: true,
            ).then((values) {
              return (
                values[0] as Player,
                values[1] as LevelProgress,
              );
            });

        if (match) {
          await ref
              .read(playerRepositoryProvider)
              .update(
                lastActiveAt: DateTime.now(),
                streakDays: calculateStreak(
                  player.streakDays,
                  player.lastActiveAt,
                ),
              );
        }

        state = AsyncData(
          current.copyWith(progress: updatedProgress),
        );
      }

      return match;
    });

    mutation.state = result;

    return result.valueOrNull ?? false;
  }
}
