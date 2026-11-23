import 'package:ctrl/features/level.dart';

final class Question {
  const new({required this.type, required this.value});

  /// Indicates how the question text should be resolved.
  final QuestionType type;

  /// Raw text or translation key depending on [type].
  final String value;
}
