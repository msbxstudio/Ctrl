import 'package:ctrl/features/level/index.dart';

final class LevelModel extends Level {
  const LevelModel(
    super.id, {
    required super.type,
    required super.keyboard,
    required super.question,
    required super.answer,
    required super.options,
    super.progress,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      json['id'] as int,

      question: json['question'],
      answer: json['answer'],

      type: switch (json['type']) {
        'missing_symbol' => LevelType.missingSymbol,
        'debug' => LevelType.debug,
        'logic' => LevelType.logic,
        'hidden_command' => LevelType.hiddenCommand,
        'complexity' => LevelType.complexity,
        _ => LevelType.outputPrediction,
      },

      keyboard: switch (json['keyboard']) {
        'symbol' => LevelKeyboard.symbol,
        'character' => LevelKeyboard.character,
        'complexity' => LevelKeyboard.complexity,
        _ => LevelKeyboard.numeric,
      },

      options: (json['options'] as List)
          .map((e) => '$e')
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': switch (type) {
        LevelType.missingSymbol => 'missing_symbol',
        LevelType.debug => 'debug',
        LevelType.logic => 'logic',
        LevelType.hiddenCommand => 'hidden_command',
        LevelType.complexity => 'complexity',
        _ => 'output_prediction',
      },
      'keyboard': switch (keyboard) {
        LevelKeyboard.symbol => 'symbol',
        LevelKeyboard.character => 'character',
        LevelKeyboard.complexity => 'complexity',
        _ => 'numeric',
      },
      'question': question,
      'answer': answer,
      'options': options,
    };
  }
}
