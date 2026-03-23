import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_radii.dart';
import 'tokens/app_typography.dart';

abstract final class AppTheme {
  /// Primary app theme — premium dark, neon accents, glass-friendly surfaces.
  /// [accentSeed] optionally recolors primary actions while keeping surfaces.
  static ThemeData dark({Color? accentSeed}) {
    const baseScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.neonPrimary,
      onPrimary: AppColors.onNeon,
      primaryContainer: Color(0xFF1E3A5C),
      onPrimaryContainer: Color(0xFFC8E4FF),
      secondary: AppColors.accentPurple,
      onSecondary: Color(0xFF1A1028),
      secondaryContainer: Color(0xFF2D2440),
      onSecondaryContainer: Color(0xFFE8DDFF),
      tertiary: AppColors.accentPink,
      onTertiary: Color(0xFF2A0A18),
      tertiaryContainer: Color(0xFF3D1A2E),
      onTertiaryContainer: Color(0xFFFFD6E8),
      error: AppColors.error,
      onError: Color(0xFF2C0A0A),
      errorContainer: Color(0xFF5C2424),
      onErrorContainer: Color(0xFFFFD6D6),
      surface: AppColors.bgSecondary,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceElevated,
      surfaceContainerHigh: Color(0xFF1C2230),
      surfaceContainer: AppColors.surfaceMuted,
      surfaceContainerLow: Color(0xFF131822),
      surfaceContainerLowest: AppColors.bgPrimary,
      surfaceDim: AppColors.bgPrimary,
      surfaceBright: Color(0xFF222838),
      onSurfaceVariant: AppColors.textSecondary,
      outline: Color(0xFF2F3545),
      outlineVariant: Color(0xFF252B38),
      shadow: Color(0xFF000000),
      scrim: AppColors.overlay,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.bgPrimary,
      inversePrimary: Color(0xFF2563EB),
      surfaceTint: AppColors.neonPrimary,
    );

    final ColorScheme scheme;
    if (accentSeed != null) {
      final d = ColorScheme.fromSeed(
        seedColor: accentSeed,
        brightness: Brightness.dark,
      );
      scheme = baseScheme.copyWith(
        primary: d.primary,
        onPrimary: d.onPrimary,
        primaryContainer: d.primaryContainer,
        onPrimaryContainer: d.onPrimaryContainer,
        surfaceTint: d.primary,
      );
    } else {
      scheme = baseScheme;
    }

    final baseText = ThemeData(brightness: Brightness.dark).textTheme;
    final textTheme = AppTypography.textTheme(baseText);

    final radiusMd = BorderRadius.circular(AppRadii.md);
    final radiusLg = BorderRadius.circular(AppRadii.lg);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: BorderSide(color: AppColors.glassBorderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.glassBorderSubtle,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 22,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: scheme.primary.withValues(alpha: 0.45),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.35),
          disabledForegroundColor: scheme.onPrimary.withValues(alpha: 0.5),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: AppColors.glassBorder),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: textTheme.titleSmall?.copyWith(color: AppColors.neonPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.titleSmall,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.glassBorderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.glassBorderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: scheme.error.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted,
          inherit: true,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted,
          inherit: true,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radiusMd),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
        modalBarrierColor: AppColors.overlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        ),
      ),
    );
  }
}
