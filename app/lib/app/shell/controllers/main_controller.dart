import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

/// Controller for [MainPage] view.
final class MainController extends AutoDisposeAsyncNotifier<MainData> {
  @override
  Future<MainData> build() async {
    final player = await ref.read(playerRepositoryProvider).get();

    final (currentLevel, solvedPuzzles, averageTime) = await Future.wait([
      ref.read(levelRepositoryProvider).getOne(id: player.currentLevelId),
      ref
          .read(levelProgressRepositoryProvider)
          .count(completed: true, distinct: true),
      ref.read(levelProgressRepositoryProvider).averageTime(),
    ]).then((r) => (r[0] as Level, r[1] as int, r[2] as int));

    return (
      player: player,
      currentLevel: currentLevel,
      solvedPuzzles: solvedPuzzles,
      averageTime: averageTime,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef MainData = ({
  Player player,
  Level currentLevel,
  int solvedPuzzles,
  int averageTime,
});
