import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    const scheme = ColorScheme.light(
      primary: AppColors.primary, // morado
      onPrimary: AppColors.white, // texto sobre primario
      secondary: AppColors.accent, // rosado
      onSecondary: AppColors.white, // texto sobre rosado
      surface: AppColors.white, // cards/sheets
      onSurface: AppColors.primary, // texto morado
      error: AppColors.error,
      onError: AppColors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: const TextTheme().apply(
        bodyColor: AppColors.primary, // todos los textos morados
        displayColor: AppColors.primary,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: AppColors.accent),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        labelStyle: const TextStyle(color: AppColors.primary),
        hintStyle: const TextStyle(color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dividerColor: AppColors.grey200,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: AppColors.white),
      ),
    );
  }
}
