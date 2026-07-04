import 'package:ctrl/features/level/index.dart';
import 'package:easy_localization/easy_localization.dart';

final class LevelQuestionModel extends LevelQuestion {
  const LevelQuestionModel({required super.type, required super.value});

  factory LevelQuestionModel.fromJson(Map<String, dynamic> json) {
    return LevelQuestionModel(
      type: switch (json['type']) {
        'key' => QuestionType.key,
        'raw' => QuestionType.raw,
        'code' => QuestionType.code,
        _ => throw Exception('Unknown question type.'),
      },
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': switch (type) {
        QuestionType.key => 'key',
        QuestionType.raw => 'raw',
        QuestionType.code => 'code',
      },
      'value': value,
    };
  }

  @override
  String resolve() {
    return switch (type) {
      QuestionType.key => value.tr(),
      _ => value,
    };
  }
}
