import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFED7125);
  static const Color secondary = Color(0xFF2B3D4E);
}

ThemeData buildAppTheme() {
  final primaryContainer = Color.lerp(AppColors.primary, Colors.white, 0.78)!;
  final secondaryContainer = Color.lerp(AppColors.secondary, Colors.white, 0.82)!;
  final surfaceTint = Color.lerp(AppColors.secondary, Colors.white, 0.95)!;

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: primaryContainer,
    onPrimaryContainer: AppColors.secondary,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: AppColors.secondary,
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: AppColors.secondary,
  );

  final borderRadius = BorderRadius.circular(12);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: surfaceTint,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: primaryContainer,
        disabledForegroundColor: AppColors.secondary.withValues(alpha: 0.6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.secondary,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.secondary, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: AppColors.secondary),
      helperStyle: TextStyle(color: AppColors.secondary.withValues(alpha: 0.7)),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: primaryContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
    ),
    dividerTheme: DividerThemeData(color: secondaryContainer, thickness: 1, space: 1),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.secondary,
      textColor: AppColors.secondary,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.secondary,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.secondary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.secondary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.secondary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.secondary),
    ),
    iconTheme: const IconThemeData(color: AppColors.secondary),
  );
}
