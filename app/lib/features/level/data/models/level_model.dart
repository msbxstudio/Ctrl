import 'dart:convert';

import 'package:ctrl/features/level.dart';

final class LevelModel extends Level {
  const LevelModel(
    super.id, {
    required super.type,
    required super.keyboard,
    required super.question,
    required super.answer,
    super.hint,
    required super.options,
    super.progress,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      json['id'] as int,

      question: LevelQuestionModel.fromJson(
        jsonDecode(json['question']) as Map<String, dynamic>,
      ),
      hint: json['hint'] != null
          ? LevelHintModel.fromJson(
              jsonDecode(json['hint']) as Map<String, dynamic>,
            )
          : null,

      answer: json['answer'],

      type: switch (json['type']) {
        'syntax' => LevelType.syntax,
        'output_prediction' => LevelType.outputPrediction,
        'logic' => LevelType.logic,
        'hidden_word' => LevelType.hiddenWord,
        'complexity' => LevelType.complexity,
        _ => throw const FormatException('Invalid level type'),
      },

      keyboard: switch (json['keyboard']) {
        'symbol' => LevelKeyboard.symbol,
        'numeric' => LevelKeyboard.numeric,
        'hidden_word' => LevelKeyboard.hiddenWord,
        'boolean' => LevelKeyboard.boolean,
        'complexity' => LevelKeyboard.complexity,
        _ => throw const FormatException('Invalid keyboard type'),
      },

      options: (jsonDecode(json['options']) as List).map((e) => '$e').toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,

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
