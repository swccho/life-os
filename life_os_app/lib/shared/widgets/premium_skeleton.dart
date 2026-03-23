import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_colors.dart';
import '../../app/theme/tokens/app_radii.dart';
import '../../app/theme/tokens/app_spacing.dart';

/// Soft pulsing placeholder bar for list loading states.
class PremiumSkeletonBar extends StatefulWidget {
  const PremiumSkeletonBar({
    super.key,
    this.height = 14,
    this.borderRadius,
  });

  final double height;
  final double? borderRadius;

  @override
  State<PremiumSkeletonBar> createState() => _PremiumSkeletonBarState();
}

class _PremiumSkeletonBarState extends State<PremiumSkeletonBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.borderRadius ?? AppRadii.md;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        final base = AppColors.surfaceMuted.withValues(alpha: 0.45);
        final hi = AppColors.surfaceElevated.withValues(alpha: 0.55);
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            gradient: LinearGradient(
              colors: [
                Color.lerp(base, hi, t)!,
                Color.lerp(hi, base, t)!,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Card-shaped skeleton row (avatar + lines).
class PremiumSkeletonListRow extends StatelessWidget {
  const PremiumSkeletonListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PremiumSkeletonBar(height: 16),
                SizedBox(height: AppSpacing.sm),
                PremiumSkeletonBar(height: 12),
                SizedBox(height: AppSpacing.xs),
                PremiumSkeletonBar(height: 12, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumSkeletonCard extends StatelessWidget {
  const PremiumSkeletonCard({super.key, this.rows = 4});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rows,
        (_) => const PremiumSkeletonListRow(),
      ),
    );
  }
}
