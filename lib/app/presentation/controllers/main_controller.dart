import 'package:ctrl/app/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/features/player/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [MainPage] view.
final class MainController extends AutoDisposeAsyncNotifier<MainData> {
  @override
  Future<MainData> build() async {
    final player = await ref.read(playerRepositoryProvider).get();
    final currentLevel = await ref
        .read(levelRepositoryProvider)
        .getOne(id: player.currentLevelId);

    return (player: player, currentLevel: currentLevel, averageTime: 0);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef MainData = ({Player player, Level currentLevel, int averageTime});
