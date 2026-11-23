import 'dart:convert';

import 'package:ctrl/features/level.dart';

final class LevelModel {
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

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] as int,

      type: LevelType.fromDbValue(map['type'] as String),
      keyboard: LevelKeyboard.fromDbValue(map['keyboard'] as String),

      question: QuestionModel.fromMap(
        jsonDecode(map['question'] as String) as Map<String, dynamic>,
      ).toEntity(),

      answer: map['answer'] as String,
      sortOrder: map['sort_order'] as int,

      hint: map['hint'] != null
          ? HintModel.fromMap(
              jsonDecode(map['hint'] as String) as Map<String, dynamic>,
            ).toEntity()
          : null,

      options: (jsonDecode(map['options'] as String) as List)
          .map((e) => '$e')
          .toList(),

      progresses: null,
    );
  }

  factory LevelModel.fromEntity(Level entity) {
    return LevelModel(
      id: entity.id,
      type: entity.type,
      keyboard: entity.keyboard,
      question: entity.question,
      answer: entity.answer,
      sortOrder: entity.sortOrder,
      hint: entity.hint,
      options: entity.options,
      progresses: entity.progresses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'type': type.toDbValue(),
      'keyboard': keyboard.toDbValue(),

      'question': jsonEncode((question as QuestionModel).toMap()),

      'answer': answer,
      'sort_order': sortOrder,

      'hint': hint != null ? jsonEncode((hint as HintModel).toMap()) : null,
      'options': jsonEncode(options),
    };
  }

  Level toEntity() {
    return Level(
      id: id,
      type: type,
      keyboard: keyboard,
      question: question,
      answer: answer,
      sortOrder: sortOrder,
      hint: hint,
      options: options,
      progresses: progresses,
    );
  }
}
