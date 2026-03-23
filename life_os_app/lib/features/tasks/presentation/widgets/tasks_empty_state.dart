import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';

class TasksEmptyState extends StatelessWidget {
  const TasksEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.onAddTask,
  });

  final String title;
  final String message;
  final VoidCallback? onAddTask;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppGlassCard(
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 48,
            color: AppColors.neonPrimary.withValues(alpha: 0.65),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onAddTask != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add your first task'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonPrimary,
                foregroundColor: AppColors.onNeon,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
