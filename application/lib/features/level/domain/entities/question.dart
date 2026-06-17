import 'package:flutter/foundation.dart';

@immutable
abstract class Question {
  /// Indicates how the question text should be resolved.
  final QuestionType type;

  /// Raw text or translation key depending on [type].
  final String value;

  const Question({required this.type, required this.value});

  /// Resolves the question text based on its [type].
  String resolve();
}

/// Defines how a question text should be interpreted.
enum QuestionType {
  /// Displays [value] exactly as stored.
  ///
  /// Example:
  /// `print(2 * 3 + 1)`
  raw,

  /// Resolves [value] using the localization system.
  ///
  /// Example:
  /// `levels.25.question`
  key,
}
