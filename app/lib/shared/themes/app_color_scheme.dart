import 'package:material_ui/material_ui.dart';

final class AppColorScheme {
  // 🌙 DARK
  static final ColorScheme dark = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFFFF7914),

    // Primary
    primary: const Color(0xFFFF7914),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFFFDBC9),
    onPrimaryContainer: const Color(0xFF331200),

    // Secondary
    secondary: const Color(0xFFBBC7DB),
    onSecondary: const Color(0xFF253140),
    secondaryContainer: const Color(0xFF3B4858),
    onSecondaryContainer: const Color(0xFFD7E3F7),

    // Tertiary
    tertiary: const Color(0xFFD6BEE4),
    onTertiary: const Color(0xFF3B2948),
    tertiaryContainer: const Color(0xFF523F5F),
    onTertiaryContainer: const Color(0xFFF2DAFF),

    // Surfaces
    // surface: const Color(0xFF0B0A0D),
    surface: const Color(0xFF111418),
    onSurface: const Color(0xFFE1E2E8),
    inverseSurface: const Color(0xFFE1E2E8),
    onInverseSurface: const Color(0xFF2E3135),

    surfaceContainerHighest: const Color(0xFF32353A),

    // Error
    error: const Color(0xFFEF4444),
    onError: const Color(0xFFFFFFFF),
  );
}
