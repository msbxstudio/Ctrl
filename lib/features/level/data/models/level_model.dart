import 'package:ctrl/features/level/index.dart';

final class LevelModel extends Level {
  const LevelModel(
    super.id, {
    required super.type,
    required super.keyboard,
    required super.question,
    required super.answer,
    required super.options,
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
          .map((e) => e as String)
          .toList(growable: false),
    );
  }
}
