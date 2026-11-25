import 'package:ctrl/features/level.dart';

final class QuestionModel {
  const new({
    required this.type,
    required this.value,
  });

  /// Indicates how the question text should be resolved.
  final QuestionType type;

  /// Raw text or translation key depending on [type].
  final String value;

  factory fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      type: QuestionType.fromDbValue(map['type'] as String),
      value: map['value'] as String,
    );
  }

  factory fromEntity(Question entity) {
    return QuestionModel(
      type: entity.type,
      value: entity.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toDbValue(),
      'value': value,
    };
  }

  Question toEntity() {
    return Question(
      type: type,
      value: value,
    );
  }
}
