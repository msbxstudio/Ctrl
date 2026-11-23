import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide Refreshable;

import 'package:msbx/contracts.dart';

import 'package:ctrl/features/level.dart';

/// Controller for [LevelsPage] view.
final class LevelsController extends AutoDisposeAsyncNotifier<LevelsState>
    implements Refreshable {
  @override
  FutureOr<LevelsState> build() async {
    final (levels, current) = await Future.wait([
      ref.read(levelRepositoryProvider).getAll(),
      ref.read(levelRepositoryProvider).getCurrent(),
    ], eagerError: true).then((r) => (r[0] as List<Level>, r[1] as Level?));

    return LevelsState(levels: levels, currentLevel: current);
  }

  @override
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
