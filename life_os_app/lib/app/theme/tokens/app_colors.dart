import 'package:flutter/material.dart';

/// LifeOS premium dark palette — semantic tokens for the global design system.
abstract final class AppColors {
  // —— Backgrounds ——
  static const Color bgPrimary = Color(0xFF0B0E14);
  static const Color bgSecondary = Color(0xFF12161F);
  static const Color bgGradientStart = Color(0xFF0A0D12);
  static const Color bgGradientMid = Color(0xFF101522);
  static const Color bgGradientEnd = Color(0xFF141228);

  /// For overlays / scrims behind sheets (not pure black).
  static const Color overlay = Color(0xB30A0C10);

  // —— Surfaces & glass ——
  static const Color glassFillTop = Color(0x26FFFFFF);
  static const Color glassFillBottom = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x2EFFFFFF);
  static const Color glassBorderSubtle = Color(0x18FFFFFF);
  static const Color surfaceElevated = Color(0xFF1A2030);
  static const Color surfaceMuted = Color(0xFF151A26);

  // —— Accents (neon-forward) ——
  static const Color neonPrimary = Color(0xFF4DA3FF);
  static const Color neonPrimaryDim = Color(0xFF2D7DD2);
  static const Color accentPurple = Color(0xFFB794F6);
  static const Color accentPink = Color(0xFFFF7AB8);
  static const Color accentCyan = Color(0xFF5EEAD4);

  // —— Text ——
  static const Color textPrimary = Color(0xFFEEF2FA);
  static const Color textSecondary = Color(0xFF9BA4B8);
  static const Color textMuted = Color(0xFF6B728E);
  static const Color textDisabled = Color(0xFF4B5263);

  // —— On-accent ——
  static const Color onNeon = Color(0xFF061018);

  // —— Status ——
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);

  // —— Glows (decorative, low alpha) ——
  static const Color glowBlue = Color(0x334DA3FF);
  static const Color glowPurple = Color(0x33B794F6);

  /// Legacy seed — prefer [neonPrimary] for new code.
  static const Color seed = neonPrimary;
}
