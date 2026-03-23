import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';

class HabitsEmptyState extends StatelessWidget {
  const HabitsEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.onCreate,
    this.actionLabel = 'Create your first habit',
  });

  final String title;
  final String message;
  final VoidCallback? onCreate;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppGlassCard(
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.auto_graph_rounded,
            size: 48,
            color: AppColors.accentCyan.withValues(alpha: 0.7),
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
          if (onCreate != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(actionLabel),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
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
