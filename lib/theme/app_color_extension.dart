import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color pri;
  final Color bg;
  final Color surface;
  final Color white;
  final Color textPri;
  final Color textSec;
  final Color error;

  const AppColorsExtension({
    required this.pri,
    required this.bg,
    required this.surface,
    required this.white,
    required this.textPri,
    required this.textSec,
    required this.error,
  });

  static const dark = AppColorsExtension(
    pri: AppColors.pri,
    bg: AppColors.bg,
    surface: AppColors.surface,
    white: AppColors.white,
    textPri: AppColors.textPri,
    textSec: AppColors.textSec,
    error: AppColors.error,
  );

  static const light = AppColorsExtension(
    pri: AppLightColors.pri,
    bg: AppLightColors.bg,
    surface: AppLightColors.surface,
    white: Colors.white, // AppLightColors has no `white` field — used for text on colored buttons/badges, stays pure white in both themes
    textPri: AppLightColors.textPri,
    textSec: AppLightColors.textSec,
    error: AppLightColors.error,
  );

  @override
  AppColorsExtension copyWith({
    Color? pri,
    Color? bg,
    Color? surface,
    Color? white,
    Color? textPri,
    Color? textSec,
    Color? error,
  }) {
    return AppColorsExtension(
      pri: pri ?? this.pri,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      white: white ?? this.white,
      textPri: textPri ?? this.textPri,
      textSec: textSec ?? this.textSec,
      error: error ?? this.error,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      pri: Color.lerp(pri, other.pri, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      white: Color.lerp(white, other.white, t)!,
      textPri: Color.lerp(textPri, other.textPri, t)!,
      textSec: Color.lerp(textSec, other.textSec, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}