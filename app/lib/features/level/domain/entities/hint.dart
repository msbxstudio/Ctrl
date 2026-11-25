import 'package:ctrl/features/level.dart';

/// Represents a hint that assists the player in solving a level.
///
/// The hint type determines how its content is interpreted.
final class Hint {
  /// Creates a hint whose content is interpreted according to [type].
  const new({
    required this.type,
    required this.value,
  });

  /// Defines the interpretation strategy of [value].
  final HintType type;

  /// Contains the hint content, as determined by [type].
  final String value;
}
