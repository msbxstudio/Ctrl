import 'package:flutter/foundation.dart';

import 'package:ctrl/features/level.dart';

@immutable
abstract class Level {
  const new({
    required this.id,
    required this.type,
    required this.keyboard,
    required this.question,
    required this.answer,
    required this.sortOrder,
    required this.hint,
    required this.options,
    required this.progress,
  });

  final int id;

  final LevelType type;

  final LevelKeyboard keyboard;

  final LevelQuestion question;

  final String answer;

  final int sortOrder;

  final LevelHint? hint;

  final List<String> options;

  final LevelProgress? progress;
}
