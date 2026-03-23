import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.days,
    this.emphasized = false,
  });

  final int days;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final color = emphasized ? AppColors.accentPink : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: emphasized ? 0.22 : 0.14),
            color.withValues(alpha: emphasized ? 0.1 : 0.06),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: emphasized ? 0.45 : 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$days day streak',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
