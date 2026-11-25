import 'package:ctrl/features/player.dart';
import 'package:ctrl/features/settings.dart';

final class SettingsState {
  const new({
    required this.player,
    required this.language,
    required this.allowSoundEffects,
  });

  final Player player;

  final AppLanguage language;

  final bool allowSoundEffects;
}
