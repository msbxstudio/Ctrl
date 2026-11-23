import 'package:easy_localization/easy_localization.dart';

import 'package:ctrl/features/level.dart';

/// Provides localized text resolution for [Question].
extension QuestionExtension on Question {
  /// Returns the translated text or the original value.
  String resolve() {
    return switch (type) {
      QuestionType.key => value.tr(),
      _ => value,
    };
  }
}
