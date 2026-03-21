import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Premium typography using Plus Jakarta Sans (headings + UI).
///
/// All styles use [inherit]: true so Material can merge / animate them without
/// "Failed to interpolate TextStyles with different inherit values".
abstract final class AppTypography {
  static TextStyle _sans({
    required double fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).copyWith(inherit: true);
  }

  static TextTheme textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: _sans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
      displayMedium: _sans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.35,
        color: AppColors.textPrimary,
      ),
      displaySmall: _sans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
      headlineLarge: _sans(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
      headlineMedium: _sans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
      headlineSmall: _sans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
      titleLarge: _sans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      titleMedium: _sans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      titleSmall: _sans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      bodyLarge: _sans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      bodyMedium: _sans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textSecondary,
      ),
      bodySmall: _sans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textMuted,
      ),
      labelLarge: _sans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
        color: AppColors.onNeon,
      ),
      labelMedium: _sans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: AppColors.textSecondary,
      ),
      labelSmall: _sans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: AppColors.textMuted,
      ),
    );
  }
}
