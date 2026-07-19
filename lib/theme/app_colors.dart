import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  static const Color pri = Color(0xFF2E9E8E); // Golden Amber
  static const Color bg = Color(0xFF121212); // Pure charcoal/Material dark
  static const Color surface = Color(0xFF1E1E1E); // Elevated charcoal
  static const Color white = Colors.white;

  static const Color textPri = Color(0xFFE0E0E0);
  static const Color textSec = Color(0xFFAAAAAA);
  static const Color error = Color(0xFFCF6679); // Material dark theme error
}

class AppLightColors {
  AppLightColors._();

  // A slightly deeper, richer cyan to maintain contrast on light backgrounds
  static const Color pri = Color(0xFF00ACC1); 
  
  // A very light, cool-toned grey so pure white cards stand out
  static const Color bg = Color(0xFFF4F6F9); 
  
  // Pure white for elevated elements (cards, search bars, bottom sheets)
  static const Color surface = Color(0xFFFFFFFF); 
  
  // The exact background color from your dark theme, reused here as the darkest color
  static const Color black = Color(0xFF0D0F16); 

  // Very dark slate blue for crisp, readable primary text
  static const Color textPri = Color(0xFF1E293B); 
  
  // Medium cool grey for subtitles and icons
  static const Color textSec = Color(0xFF64748B); 
  
  // A slightly deeper red for error messages to ensure readability
  static const Color error = Color(0xFFE53935); 
}