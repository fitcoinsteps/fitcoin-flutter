import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.lightBlueAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: Colors.black,
      cardTheme: CardThemeData(  // Changed from CardTheme to CardThemeData
        color: Colors.grey[900],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.lightBlue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(  // Changed from CardTheme to CardThemeData
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}