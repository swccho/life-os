import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../mood/data/models/mood_level.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../data/models/dashboard_summary_model.dart';

/// Primary daily overview — glass hero with light metrics and a calm line of copy.
class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({
    super.key,
    required this.summary,
    this.isLoading = false,
  });

  final DashboardSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    final headline = isLoading || summary == null
        ? 'Loading your day…'
        : summary!.latestJournalEntry?.title.isNotEmpty == true
            ? summary!.latestJournalEntry!.title
            : summary!.recentTasks.isNotEmpty
                ? summary!.recentTasks.first.title
                : 'Welcome back';

    final openTasks = summary == null
        ? '—'
        : '${summary!.pendingTasks + summary!.inProgressTasks}';
    final habits = summary == null
        ? '—'
        : '${summary!.todayHabitLogsCount}/${summary!.activeHabitsCount}';
    final moodLabel = summary?.latestMoodEntry?.mood.label ?? 'Not logged';

    return AppGlassCard(
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: scheme.primary, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Today’s overview',
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.md),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.neonPrimary.withValues(alpha: 0.08),
                  AppColors.accentPurple.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(
                color: AppColors.glassBorderSubtle,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _HeroChip(
                        icon: Icons.task_alt_rounded,
                        label: '$openTasks tasks open',
                      ),
                      _HeroChip(
                        icon: Icons.autorenew_rounded,
                        label: '$habits habits',
                      ),
                      _HeroChip(
                        icon: Icons.mood_rounded,
                        label: 'Mood: $moodLabel',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Stay consistent — clarity beats intensity.',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        color: AppColors.surfaceMuted.withValues(alpha: 0.65),
        border: Border.all(color: AppColors.glassBorderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
