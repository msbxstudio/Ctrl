import 'package:easy_localization/easy_localization.dart';

import 'package:ctrl/features/level.dart';

/// Provides localized text resolution for [Hint].
extension HintExtension on Hint {
  /// Returns the translated text or the original value.
  String resolve() {
    return switch (type) {
      HintType.key => value.tr(),
      _ => value,
    };
  }
}
