import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/features/player/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [LevelsPage] view.
final class LevelsController extends AutoDisposeAsyncNotifier<LevelsData> {
  @override
  Future<LevelsData> build() async {
    final (levels, player) = await Future.wait([
      ref.read(levelRepositoryProvider).getAll(),
      ref.read(playerRepositoryProvider).get(),
    ], eagerError: true).then((r) => (r[0] as List<Level>, r[1] as Player));

    final currentLevel = await ref
        .read(levelRepositoryProvider)
        .getOne(id: player.currentLevelId);

    return (levels: levels, currentLevel: currentLevel);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef LevelsData = ({List<Level> levels, Level currentLevel});
