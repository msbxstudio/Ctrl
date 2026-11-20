import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;
import 'package:msbx/contracts.dart';

import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

/// Controller for [LevelsPage] view.
final class LevelsController extends AutoDisposeAsyncNotifier<LevelsState>
    implements Refreshable {
  @override
  FutureOr<LevelsState> build() async {
    final (levels, player) = await Future.wait([
      ref.read(levelRepositoryProvider).getAll(),
      ref.read(playerRepositoryProvider).get(),
    ], eagerError: true).then((r) => (r[0] as List<Level>, r[1] as Player));

    final currentLevel = await ref
        .read(levelRepositoryProvider)
        .getOne(id: player.currentLevelId);

    return LevelsState(levels: levels, currentLevel: currentLevel);
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
