import 'package:ctrl/features/level/index.dart';
import 'package:easy_localization/easy_localization.dart';

final class QuestionModel extends Question {
  const QuestionModel({required super.type, required super.value});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      type: switch (json['type']) {
        'key' => QuestionType.key,
        _ => QuestionType.raw,
      },
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': switch (type) {
        QuestionType.key => 'key',
        _ => 'value',
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
