import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_radii.dart';

/// Primary neon CTA — fixed height, loading state, matches theme.
///
/// Avoids [AnimatedSwitcher] inside [FilledButton] so Material’s internal
/// [DefaultTextStyle] transitions do not fight with animated children (which
/// caused TextStyle inherit interpolation errors).
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          elevation: 0,
          shadowColor: scheme.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          disabledBackgroundColor: scheme.primary,
          disabledForegroundColor: scheme.onPrimary,
        ),
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: scheme.onPrimary,
                    ),
                  ),
                  if (loadingLabel != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      loadingLabel!,
                      style: textStyle?.copyWith(
                        color: scheme.onPrimary,
                        inherit: true,
                      ),
                    ),
                  ],
                ],
              )
            : Text(
                label,
                style: textStyle?.copyWith(inherit: true),
              ),
      ),
    );
  }
}
