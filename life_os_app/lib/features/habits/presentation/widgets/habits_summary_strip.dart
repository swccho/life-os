import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../providers/habits_notifier.dart';

class HabitsSummaryStrip extends StatelessWidget {
  const HabitsSummaryStrip({super.key, required this.stats});

  final HabitSummaryStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Momentum',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _StatChip(
                label: 'Done today',
                value: '${stats.completedToday}/${stats.eligibleToday}',
                accent: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                label: 'Total habits',
                value: '${stats.totalHabits}',
                accent: AppColors.neonPrimary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                label: 'Best streak',
                value: '${stats.bestStreak}d',
                accent: AppColors.accentPink,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                label: 'Consistency',
                value: '${stats.consistencyScore}%',
                accent: AppColors.accentPurple,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 118,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceElevated.withValues(alpha: 0.75),
              AppColors.surfaceMuted.withValues(alpha: 0.65),
            ],
          ),
          border: Border.all(
            color: accent.withValues(alpha: 0.28),
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
