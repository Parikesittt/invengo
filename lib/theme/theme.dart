import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.backgroundLight,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.secondary,
      surface: AppColor.surfaceLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColor.textPrimaryLight,
      onSurfaceVariant: AppColor.textSecondaryLight,
      outline: AppColor.borderLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.backgroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.textPrimaryLight),
      titleTextStyle: TextStyle(
        color: AppColor.textPrimaryLight,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColor.textPrimaryLight),
      displayMedium: TextStyle(color: AppColor.textPrimaryLight),
      displaySmall: TextStyle(color: AppColor.textPrimaryLight),
      headlineMedium: TextStyle(color: AppColor.textPrimaryLight),
      headlineSmall: TextStyle(color: AppColor.textPrimaryLight),
      titleLarge: TextStyle(color: AppColor.textPrimaryLight),
      bodyLarge: TextStyle(color: AppColor.textPrimaryLight),
      bodyMedium: TextStyle(color: AppColor.textPrimaryLight),
      labelLarge: TextStyle(color: AppColor.textPrimaryLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColor.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.backgroundDark,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.dark(
      primary: AppColor.primaryDark,
      secondary: AppColor.secondaryDark,
      surface: AppColor.surfaceDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColor.textPrimaryDark,
      onSurfaceVariant: AppColor.textSecondaryDark,
      outline: AppColor.borderDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.textPrimaryDark),
      titleTextStyle: TextStyle(
        color: AppColor.textPrimaryDark,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColor.textPrimaryDark),
      displayMedium: TextStyle(color: AppColor.textPrimaryDark),
      displaySmall: TextStyle(color: AppColor.textPrimaryDark),
      headlineMedium: TextStyle(color: AppColor.textPrimaryDark),
      headlineSmall: TextStyle(color: AppColor.textPrimaryDark),
      titleLarge: TextStyle(color: AppColor.textPrimaryDark),
      bodyLarge: TextStyle(color: AppColor.textPrimaryDark),
      bodyMedium: TextStyle(color: AppColor.textSecondaryDark),
      labelLarge: TextStyle(color: AppColor.textPrimaryDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primaryDark),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColor.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
  );
}
