import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../mood/data/models/mood_level.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/dashboard_preview_data.dart';
import '../../data/models/dashboard_summary_model.dart';

class DashboardActivitySection extends StatelessWidget {
  const DashboardActivitySection({
    super.key,
    required this.summary,
    this.isLoading = false,
  });

  final DashboardSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final activities = isLoading || summary == null
        ? DashboardPreviewData.activities.take(3).toList()
        : _buildFromSummary(summary!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent activity', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...activities.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ActivityRow(item: item),
          ),
        ),
      ],
    );
  }
}

List<DashboardActivityItem> _buildFromSummary(DashboardSummary s) {
  final rows = <({DashboardActivityItem item, DateTime t})>[];

  for (final t in s.recentTasks) {
    rows.add((
      item: DashboardActivityItem(
        title: t.title,
        category: 'Task',
        icon: Icons.task_alt_rounded,
        accent: AppColors.neonPrimary,
      ),
      t: t.createdAt,
    ));
  }
  for (final j in s.recentJournalEntries) {
    rows.add((
      item: DashboardActivityItem(
        title: j.title.isEmpty ? 'Journal entry' : j.title,
        category: 'Journal',
        icon: Icons.menu_book_rounded,
        accent: AppColors.accentPurple,
      ),
      t: j.createdAt,
    ));
  }
  for (final m in s.recentMoodEntries) {
    rows.add((
      item: DashboardActivityItem(
        title: 'Mood: ${m.mood.label}',
        category: 'Mood',
        icon: Icons.sentiment_satisfied_alt_rounded,
        accent: AppColors.accentPink,
      ),
      t: m.loggedAt,
    ));
  }

  if (rows.isEmpty) {
    return [
      const DashboardActivityItem(
        title: 'No recent activity yet',
        category: 'LifeOS',
        icon: Icons.auto_awesome_rounded,
        accent: AppColors.accentCyan,
      ),
    ];
  }

  rows.sort((a, b) => b.t.compareTo(a.t));
  return rows.take(5).map((e) => e.item).toList();
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final DashboardActivityItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppRadii.md),
        splashColor: item.accent.withValues(alpha: 0.08),
        highlightColor: item.accent.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md),
            color: AppColors.surfaceMuted.withValues(alpha: 0.45),
            border: Border.all(color: AppColors.glassBorderSubtle),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    color: item.accent.withValues(alpha: 0.12),
                    border: Border.all(
                      color: item.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(item.icon, color: item.accent, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.category,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
