import 'package:ctrl/features/level/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [LevelPage] view.
final class LevelController
    extends AutoDisposeFamilyAsyncNotifier<LevelData, int> {
  @override
  Future<LevelData> build(int id) async {
    final level = await ref.read(levelRepositoryProvider).getOne(id: id);
    return (level: level);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef LevelData = ({Level level});
