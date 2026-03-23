import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

class HabitPageHeader extends StatelessWidget {
  const HabitPageHeader({
    super.key,
    required this.subtitle,
    this.onAddHabit,
  });

  final String subtitle;
  final VoidCallback? onAddHabit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habits',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onAddHabit != null)
            IconButton(
              onPressed: onAddHabit,
              tooltip: 'Add habit',
              style: IconButton.styleFrom(
                foregroundColor: AppColors.accentCyan,
              ),
              icon: const Icon(Icons.add_rounded, size: 28),
            ),
        ],
      ),
    );
  }
}
