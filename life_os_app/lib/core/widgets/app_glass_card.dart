import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_colors.dart';
import '../../app/theme/tokens/app_radii.dart';

/// Frosted-glass panel: translucent layers, soft border, depth — no heavy blur.
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppRadii.lg;
    final blurTint = elevated ? 0.22 : 0.16;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(AppColors.glassFillTop, Colors.white, blurTint * 0.15)!,
            AppColors.glassFillBottom,
          ],
        ),
        border: Border.all(
          color: elevated ? AppColors.glassBorder : AppColors.glassBorderSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPrimary.withValues(alpha: elevated ? 0.12 : 0.07),
            blurRadius: elevated ? 32 : 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}
