import 'package:flutter/foundation.dart';
import 'package:ctrl/features/settings.dart';

@immutable
final class Preferences {
  /// ...
  const new({required this.language, required this.allowSounds});

  ///
  const new defaults() : language = AppLanguage.en, allowSounds = true;

  /// ...
  final AppLanguage language;

  /// ...
  final bool allowSounds;
}
