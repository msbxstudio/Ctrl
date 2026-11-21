import 'package:ctrl/features/player.dart';

final class const SettingsState({
  required this.player,
  required this.langCode,
  required this.soundEffects,
}) {
  final Player player;
  final String langCode;
  final bool soundEffects;
}
