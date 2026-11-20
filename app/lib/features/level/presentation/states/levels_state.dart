import 'package:msbx/contracts.dart';
import 'package:ctrl/features/level.dart';

final class const LevelsState({
  required this.levels,
  required this.currentLevel,
}) implements Copyable<LevelsState> {
  ///
  final List<Level> levels;

  ///
  final Level currentLevel;

  @override
  LevelsState copyWith({List<Level>? levels, Level? currentLevel}) {
    return LevelsState(
      levels: levels ?? this.levels,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }
}
