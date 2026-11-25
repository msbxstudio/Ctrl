import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';

import 'package:ctrl/features/home.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

/// Controller for [MainPage] view.
final class MainController extends AutoDisposeAsyncNotifier<HomeState>
    implements Refreshable {
  @override
  FutureOr<HomeState> build() async {
    final player = await ref.read(playerRepositoryProvider).get();

    final (
      currentLevel,
      solvedPuzzles,
      averageTime,
    ) = await Future.wait([
      /// ...
      ref.read(levelRepositoryProvider).getCurrent(),

      /// ...
      ref.read(levelRepositoryProvider).getCount(LevelCountFilter.completed),

      /// ...
      ref.read(levelProgressRepositoryProvider).averageTime(),
    ], eagerError: true).then((r) {
      return (
        r[0] as Level,
        r[1] as int,
        r[2] as int,
      );
    });

    return HomeState(
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
