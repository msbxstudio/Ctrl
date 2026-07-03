import 'package:flutter/foundation.dart';

@immutable
abstract class LevelHint {
  final HintType type;
  final String value;

  @protected
  const LevelHint({required this.type, required this.value});

  /// Resolves the hint text based on its [type].
  String resolve();
}

/// Enum that represents the type of hint.
enum HintType {
  /// A hint that is a raw text.
  raw,

  /// A hint that is a translation key.
  key,
}
