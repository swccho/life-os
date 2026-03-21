import 'package:flutter/material.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_radii.dart';

/// Glass-style input decoration aligned with [ThemeData] dark scheme.
InputDecoration lifeInputDecoration(
  BuildContext context, {
  required String label,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  final scheme = Theme.of(context).colorScheme;
  final radius = BorderRadius.circular(AppRadii.md);

  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted,
          inherit: true,
        ),
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted,
          inherit: true,
        ),
    prefixIcon: prefixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.glassBorderSubtle),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.glassBorderSubtle),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error.withValues(alpha: 0.65)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error, width: 2),
    ),
  );
}

Color lifeMutedIconColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.65);
}
