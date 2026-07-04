import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color_extension.dart';
import 'app_color_scheme.dart';

extension AppThemeData on ThemeData {
  // 🌙 DARK THEME
  ThemeData get dark {
    final scheme = AppColorScheme.dark;

    return _base(scheme, Brightness.dark);
  }

  // 🔁 BASE THEME
  ThemeData _base(ColorScheme scheme, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      applyElevationOverlayColor: brightness == Brightness.dark,

      textTheme: const TextTheme(
        labelSmall: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10.0),
        labelMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12.0),
        labelLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14.0),

        bodySmall: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12.0),
        bodyMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14.0),
        bodyLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16.0),

        titleSmall: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14.0),
        titleMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 18.0),
        titleLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 22.0),

        headlineSmall: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 24.0),
        headlineMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 30.0),
        headlineLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 36.0),

        displaySmall: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 42.0),
        displayMedium: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 50.0),
        displayLarge: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 58.0),
      ),

      dividerTheme: DividerThemeData(color: scheme.outlineVariant),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.minPositive, 44.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.minPositive, 44),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.minPositive, 44.0),
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? scheme.outlineVariant
                  : scheme.primary,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(style: const ButtonStyle()),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(Size.zero),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: TextStyle(color: scheme.outline.withValues(alpha: 0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: scheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(scheme.surface),
        elevation: WidgetStateProperty.all(0),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        side: BorderSide.none,
        showCheckmark: false,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),

      appBarTheme: AppBarThemeData(
        leadingWidth: 64.0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
      ),

      extensions: const [AppColorExtension.dark],
    );
  }
}
