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

    final level = await Future.wait([
      ref.read(levelRepositoryProvider).getOne(id: levelId),
      ref.read(playerRepositoryProvider).update(currentLevelId: levelId),
    ], eagerError: true).then((r) => (r[0] as Level));

    return (level: level);
  }

  bool checkAnswer(String answer) {
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

      notifier.state = notifier.state.copyWith(isLoading: false);
      return state.value!.level.answer == answer;
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

typedef LevelData = ({Level level});
