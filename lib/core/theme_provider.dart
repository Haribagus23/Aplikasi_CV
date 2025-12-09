import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  // Dark Theme
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    primaryColor: Colors.cyanAccent,
    colorScheme: const ColorScheme.dark(
      primary: Colors.cyanAccent,
      surface: Color(0xFF1A1A1A),
      onSurface: Colors.white,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
  );

  // Light Theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F2F5),
    primaryColor: const Color(0xFF007AFF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007AFF),
      surface: Colors.white,
      onSurface: Color(0xFF1D1D1F),
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF424245))),
  );
}
