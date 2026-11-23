import 'package:ctrl/features/level.dart';

final class Level {
  const new({
    required this.id,
    required this.type,
    required this.keyboard,
    required this.question,
    required this.answer,
    required this.sortOrder,
    required this.hint,
    required this.options,
    required this.progresses,
  });

  final int id;

  final LevelType type;

  final LevelKeyboard keyboard;

  final Question question;

  final String answer;

  final int sortOrder;

  final Hint? hint;

  final List<String> options;

  final List<LevelProgress>? progresses;
}
