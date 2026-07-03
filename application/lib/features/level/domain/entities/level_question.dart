import 'package:flutter/foundation.dart';

@immutable
abstract class LevelQuestion {
  /// Indicates how the question text should be resolved.
  final QuestionType type;

  /// Raw text or translation key depending on [type].
  final String value;

  @protected
  const LevelQuestion({required this.type, required this.value});

  /// Resolves the question text based on its [type].
  String resolve();
}

/// Defines how the question text should be interpreted.
enum QuestionType {
  /// Uses the provided text exactly as it is.
  ///
  /// Example:
  /// `What is the output of this code?`
  raw,

  /// Resolves the text through the localization system using a translation key.
  ///
  /// Example:
  /// `levels.25.question`
  key,

  /// Treats the text as a code snippet that should be rendered using the
  /// application's code presentation UI.
  ///
  /// Example:
  /// `print("Hello, World!");`
  code,
}
