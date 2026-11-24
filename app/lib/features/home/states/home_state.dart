import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/player.dart';

final class HomeState {
  const new({
    required this.player,
    required this.currentLevel,
    required this.solvedPuzzles,
    required this.averageTime,
  });

  final Player player;
  final Level currentLevel;
  final int solvedPuzzles;
  final int averageTime;
}
