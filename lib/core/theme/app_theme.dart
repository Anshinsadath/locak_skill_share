import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2E6F40);
  static const Color secondary = Color(0xFF68BA7F);
  static const Color background = Color(0xFFCFFFDC);
  static const Color dark = Color(0xFF253D2C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        background: background,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromARGB(255, 33, 33, 33),
        elevation: 0,
      ),

      cardTheme: CardThemeData(
  color: const Color.fromARGB(255, 255, 255, 255),
  elevation: 6,
  shadowColor: Colors.black26,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
),


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: primary,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        showUnselectedLabels: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
