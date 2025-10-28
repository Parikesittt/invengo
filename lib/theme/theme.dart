import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF8B5CF6), // Violet
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF8B5CF6),
    secondary: Color(0xFFEC4899), // Pink accent
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF8F9FA),
    error: Color(0xFFEF4444),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF111827),
    onBackground: Color(0xFF111827),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFE5E7EB),
  shadowColor: Colors.black.withValues(alpha: 0.1),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF111827)), // primary text
    bodyMedium: TextStyle(color: Color(0xFF6B7280)), // secondary text
    bodySmall: TextStyle(color: Color(0xFF9CA3AF)), // muted text
  ),

  iconTheme: const IconThemeData(color: Color(0xFF374151)), // moon icon
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    foregroundColor: Color(0xFF111827),
    elevation: 1,
  ),

  // Accent buttons or elevated buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  // Glassmorphism-style container
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white.withValues(alpha: 0.9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF8B5CF6),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8B5CF6),
    secondary: Color(0xFFEC4899),
    surface: Color(0xFF1E293B),
    background: Color(0xFF0F172A),
    error: Color(0xFFEF4444),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E293B),
  dividerColor: Colors.white.withValues(alpha: 0.1),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // primary text
    bodyMedium: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)), // secondary
    bodySmall: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.4)), // muted
  ),

  iconTheme: const IconThemeData(color: Color(0xFFFBBF24)), // sun icon
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  // Glassmorphism style
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
    ),
  ),
);

