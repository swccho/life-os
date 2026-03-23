import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/dashboard_summary_model.dart';

class DashboardStatsSection extends StatelessWidget {
  const DashboardStatsSection({
    super.key,
    required this.summary,
    this.isLoading = false,
  });

  final DashboardSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = isLoading || summary == null
        ? const [
            _StatData('…', 'Tasks today'),
            _StatData('…', 'Habits today'),
            _StatData('…', 'Journal'),
            _StatData('…', 'Mood avg'),
          ]
        : [
            _StatData(
              '${summary!.pendingTasks + summary!.inProgressTasks}',
              'Open tasks',
            ),
            _StatData(
              '${summary!.todayHabitLogsCount}/${summary!.activeHabitsCount}',
              'Habits today',
            ),
            _StatData(
              '${summary!.recentJournalEntries.length}',
              'Recent journal',
            ),
            _StatData(
              summary!.averageMoodLast7Days != null
                  ? summary!.averageMoodLast7Days!.toStringAsFixed(1)
                  : '—',
              'Mood (7d avg)',
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('At a glance', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              return _StatCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _StatData {
  const _StatData(this.value, this.label);

  final String value;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatData item;

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
            color: AppColors.neonPrimary.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPrimary.withValues(alpha: 0.06),
              blurRadius: 16,
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
                item.value,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
