import 'package:flutter/material.dart';

class MyAppTheme {
  static bool isDark = false;

  static ColorScheme colorScheme = isDark ? _colorSchemeDark : _colorSchemeLight;

  // Light mode
  static const ColorScheme _colorSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0),     // Deep Blue
    secondary: Color(0xFF29B6F6),   // Sky Blue
    tertiary: Color(0xFFFFA726),    // Orange
    error: Color(0xFFE53935),       // Red
    background: Color(0xFFFDFDFD),  // Soft White
    surface: Color(0xFFFFFFFF),     // White cards
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF003B57),
    onTertiary: Color(0xFF4A2500),
    onBackground: Color(0xFF1C1C1C),
    onSurface: Color(0xFF1C1C1C),
    onError: Color(0xFFFFFFFF),
  );

  // Dark mode
  static const ColorScheme _colorSchemeDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9),     // Light Blue
    secondary: Color(0xFF4DD0E1),   // Cyan
    tertiary: Color(0xFFFFB74D),    // Soft Orange
    error: Color(0xFFEF9A9A),       // Soft Red
    background: Color(0xFF121212),  // Dark background
    surface: Color(0xFF1E1E1E),     // Dark cards
    onPrimary: Color(0xFF0D47A1),
    onSecondary: Color(0xFF003B57),
    onTertiary: Color(0xFF4A2500),
    onBackground: Color(0xFFE0E0E0),
    onSurface: Color(0xFFE0E0E0),
    onError: Color(0xFFB71C1C),
  );

  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1565C0), // Deep Blue
      foregroundColor: Colors.white,
    ),
    colorScheme: _colorSchemeLight,
    fontFamily: 'Roboto',
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D47A1), // Navy Blue
      foregroundColor: Colors.white,
    ),
    colorScheme: _colorSchemeDark,
    fontFamily: 'Roboto',
  );
}
