import 'package:flutter/material.dart';

class ThemeConstants {
  // Color Palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color secondaryBlue = Color(0xFF1976D2);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color lightBlue = Color(0xFFE3F2FD);
  
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color secondaryOrange = Color(0xFFF57C00);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color lightOrange = Color(0xFFFFF3E0);
  
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color secondaryGreen = Color(0xFF388E3C);
  static const Color accentGreen = Color(0xFF81C784);
  static const Color lightGreen = Color(0xFFE8F5E8);
  
  static const Color primaryRed = Color(0xFFF44336);
  static const Color secondaryRed = Color(0xFFD32F2F);
  static const Color accentRed = Color(0xFFE57373);
  static const Color lightRed = Color(0xFFFFEBEE);
  
  static const Color darkGrey = Color(0xFF424242);
  static const Color mediumGrey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color veryLightGrey = Color(0xFFF5F5F5);
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  
  // Weather-specific Colors
  static const Color sunnyGradientStart = Color(0xFFFFD54F);
  static const Color sunnyGradientEnd = Color(0xFFFFB300);
  static const Color cloudyGradientStart = Color(0xFF90A4AE);
  static const Color cloudyGradientEnd = Color(0xFF546E7A);
  static const Color rainyGradientStart = Color(0xFF42A5F5);
  static const Color rainyGradientEnd = Color(0xFF1976D2);
  static const Color snowyGradientStart = Color(0xFFE1F5FE);
  static const Color snowyGradientEnd = Color(0xFF81D4FA);
  static const Color nightGradientStart = Color(0xFF37474F);
  static const Color nightGradientEnd = Color(0xFF263238);
  
  // Text Styles
  static TextStyle get heading1 => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkGrey,
  );
  
  static TextStyle get heading2 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: darkGrey,
  );
  
  static TextStyle get heading3 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: darkGrey,
  );
  
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: darkGrey,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: mediumGrey,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );
  
  static TextStyle get caption => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: lightGrey,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
  
  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: black.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];
} 