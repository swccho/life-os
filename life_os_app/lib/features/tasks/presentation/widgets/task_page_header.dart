import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

class TaskPageHeader extends StatelessWidget {
  const TaskPageHeader({
    super.key,
    required this.subtitle,
    this.onAddTask,
  });

  final String subtitle;
  final VoidCallback? onAddTask;

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
                  'Tasks',
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
          if (onAddTask != null)
            IconButton(
              onPressed: onAddTask,
              tooltip: 'Add task',
              style: IconButton.styleFrom(
                foregroundColor: AppColors.neonPrimary,
              ),
              icon: const Icon(Icons.add_rounded, size: 28),
            ),
        ],
      ),
    );
  }
}
