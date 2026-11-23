import 'dart:convert';

import 'package:ctrl/features/level.dart';

final class LevelModel extends Level {
  const new({
    required super.id,
    required super.type,
    required super.keyboard,
    required super.question,
    required super.answer,
    required super.sortOrder,
    required super.hint,
    required super.options,
    required super.progress,
  });

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] as int,

      question: LevelQuestionModel.fromJson(
        jsonDecode(map['question']) as Map<String, dynamic>,
      ),
      hint: map['hint'] != null
          ? LevelHintModel.fromJson(
              jsonDecode(map['hint']) as Map<String, dynamic>,
            )
          : null,

      answer: map['answer'],
      sortOrder: map['sort_order'],

      type: switch (map['type']) {
        'syntax' => LevelType.syntax,
        'output_prediction' => LevelType.outputPrediction,
        'logic' => LevelType.logic,
        'hidden_word' => LevelType.hiddenWord,
        'complexity' => LevelType.complexity,
        _ => throw const FormatException('Invalid level type'),
      },

      keyboard: switch (map['keyboard']) {
        'symbol' => LevelKeyboard.symbol,
        'numeric' => LevelKeyboard.numeric,
        'hidden_word' => LevelKeyboard.hiddenWord,
        'boolean' => LevelKeyboard.boolean,
        'complexity' => LevelKeyboard.complexity,
        _ => throw const FormatException('Invalid keyboard type'),
      },

      options: (jsonDecode(map['options']) as List).map((e) => '$e').toList(),

      progress: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer': answer,
      'sort_order': sortOrder,

      'type': switch (type) {
        LevelType.syntax => 'syntax',
        LevelType.outputPrediction => 'output_prediction',
        LevelType.logic => 'logic',
        LevelType.hiddenWord => 'hidden_word',
        LevelType.complexity => 'complexity',
      },

      'keyboard': switch (keyboard) {
        LevelKeyboard.symbol => 'symbol',
        LevelKeyboard.numeric => 'numeric',
        LevelKeyboard.hiddenWord => 'hidden_word',
        LevelKeyboard.boolean => 'boolean',
        LevelKeyboard.complexity => 'complexity',
      },

      'question': jsonEncode((question as LevelQuestionModel).toJson()),
      'hint': hint != null
          ? jsonEncode((hint as LevelHintModel).toJson())
          : null,
      'options': jsonEncode(options),
    };
  }
}
