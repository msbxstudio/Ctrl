import 'package:flutter/material.dart';

final class AppColorScheme {
  // 🌙 DARK
  static final ColorScheme dark = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF813EF4),

    // Primary
    primary: const Color(0xFF813EF4),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFEADDFF),
    onPrimaryContainer: const Color(0xFF24005B),

    // Secondary
    secondary: const Color(0xFFCDC2DB),
    onSecondary: const Color(0xFF342D40),
    secondaryContainer: const Color(0xFF4B4358),
    onSecondaryContainer: const Color(0xFFE9DEF8),

    // Tertiary
    tertiary: const Color(0xFFF0B7C5),
    onTertiary: const Color(0xFF4A2530),
    tertiaryContainer: const Color(0xFF643B46),
    onTertiaryContainer: const Color(0xFFFFD9E1),

    // Surfaces
    surface: const Color(0xFF151218),
    onSurface: const Color(0xFFE7E0E8),
    inverseSurface: const Color(0xFFE7E0E8),
    onInverseSurface: const Color(0xFF322F35),

    // Error
    error: const Color(0xFFEF4444),
    onError: const Color(0xFFFFFFFF),
  );
}
