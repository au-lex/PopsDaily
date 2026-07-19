import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_color_extension.dart';

class AppTheme {
  AppTheme._();

  static const String headingFont = 'WorkSans';
  static const String bodyFont = 'WorkSans';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pri,
        brightness: Brightness.dark,
        surface: AppColors.bg,
        onSurface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      canvasColor: AppColors.bg,
      dialogBackgroundColor: AppColors.bg,
      primaryColor: AppColors.pri,
      fontFamily: bodyFont,
      extensions: const [AppColorsExtension.dark],
      // textTheme: TextTheme(
      //   displayLarge: const TextStyle(
      //     fontFamily: headingFont,
      //     fontSize: 32,
      //     fontWeight: FontWeight.w700,
      //     color: AppColors.white,
      //   ),
      //   headlineMedium: const TextStyle(
      //     fontFamily: headingFont,
      //     fontSize: 26,
      //     fontWeight: FontWeight.w800,
      //     color: AppColors.white,
      //   ),
      //   titleLarge: const TextStyle(
      //     fontFamily: headingFont,
      //     fontSize: 20,
      //     fontWeight: FontWeight.w600,
      //     color: AppColors.white,
      //   ),
      //   bodyLarge: const TextStyle(
      //     fontFamily: bodyFont,
      //     fontSize: 18,
      //     fontWeight: FontWeight.w600,
      //     color: AppColors.white,
      //   ),
      //   bodyMedium: const TextStyle(
      //     fontFamily: bodyFont,
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppColors.white,
      //   ),
      //   labelLarge: const TextStyle(
      //     fontFamily: bodyFont,
      //     fontSize: 14,
      //     fontWeight: FontWeight.w500,
      //     color: AppColors.white,
      //   ),
      // ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pri,
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppLightColors.pri,
        brightness: Brightness.light,
        surface: AppLightColors.bg,
        onSurface: AppLightColors.textPri,
      ),
      scaffoldBackgroundColor: AppLightColors.bg,
      canvasColor: AppLightColors.bg,
      dialogBackgroundColor: AppLightColors.surface,
      primaryColor: AppLightColors.pri,
      fontFamily: bodyFont,
      extensions: const [AppColorsExtension.light],
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontFamily: headingFont,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppLightColors.textPri,
        ),
        headlineMedium: const TextStyle(
          fontFamily: headingFont,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppLightColors.textPri,
        ),
        titleLarge: const TextStyle(
          fontFamily: headingFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppLightColors.textPri,
        ),
        bodyLarge: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppLightColors.textPri,
        ),
        bodyMedium: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppLightColors.textPri,
        ),
        labelLarge: const TextStyle(
          fontFamily: bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppLightColors.textPri,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppLightColors.bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppLightColors.pri,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}