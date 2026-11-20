import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';

import 'package:ctrl/app/shell.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

/// Controller for [MainPage] view.
final class MainController extends AutoDisposeAsyncNotifier<MainState>
    implements Refreshable {
  @override
  Future<MainState> build() async {
    final player = await ref.read(playerRepositoryProvider).get();

    final (currentLevel, solvedPuzzles, averageTime) = await Future.wait([
      ref.read(levelRepositoryProvider).getOne(id: player.currentLevelId),
      ref
          .read(levelProgressRepositoryProvider)
          .count(completed: true, distinct: true),
      ref.read(levelProgressRepositoryProvider).averageTime(),
    ]).then((r) => (r[0] as Level, r[1] as int, r[2] as int));

    return MainState(
      player: player,
      currentLevel: currentLevel,
      solvedPuzzles: solvedPuzzles,
      averageTime: averageTime,
    );
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
