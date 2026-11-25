import 'package:ctrl/features/level.dart';

/// Represents the content of a level's question.
///
/// The question type determines whether its content is self-contained
/// or requires localization before being presented to the player.
final class Question {
  /// Creates a question whose content is interpreted according to [type].
  ///
  /// The supplied [value] must conform to the content semantics
  /// defined by the selected [type].
  const new({
    required this.type,
    required this.value,
  });

  /// Defines the interpretation and resolution strategy of [value].
  final QuestionType type;

  /// Contains either literal question content or a localization key,
  /// as determined by [type].
  final String value;
}
