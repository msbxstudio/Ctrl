import 'package:ctrl/features/level.dart';

final class LevelsState {
  ///
  const new({required this.levels, required this.currentLevel});

  ///
  final List<Level> levels;

  ///
  final Level? currentLevel;
}
