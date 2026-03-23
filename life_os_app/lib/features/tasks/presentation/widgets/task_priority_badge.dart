import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../data/models/task_model.dart';
import '../utils/task_display_strings.dart';

class TaskPriorityBadge extends StatelessWidget {
  const TaskPriorityBadge({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (priority) {
      TaskPriority.high => (
          AppColors.neonPrimary,
          AppColors.neonPrimary.withValues(alpha: 0.14),
        ),
      TaskPriority.medium => (
          AppColors.warning,
          AppColors.warning.withValues(alpha: 0.12),
        ),
      TaskPriority.low => (
          AppColors.textMuted,
          AppColors.textMuted.withValues(alpha: 0.12),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        TaskDisplayStrings.priority(priority),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
