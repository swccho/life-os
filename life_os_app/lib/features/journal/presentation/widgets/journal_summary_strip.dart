import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../providers/journal_notifier.dart';

class JournalSummaryStrip extends StatelessWidget {
  const JournalSummaryStrip({super.key, required this.stats});

  final JournalStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final last = stats.lastEntryAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'At a glance',
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
              _SummaryCard(
                label: 'Total entries',
                value: '${stats.totalEntries}',
                accent: AppColors.accentPurple,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryCard(
                label: 'This week',
                value: '${stats.thisWeekCount}',
                accent: AppColors.accentCyan,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryCard(
                label: 'Streak',
                value: '${stats.streakDays}d',
                accent: AppColors.info,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryCard(
                label: 'Last entry',
                value: last == null
                    ? '—'
                    : DateFormat.MMMd().format(last),
                accent: AppColors.accentPink,
                smallValue: last != null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.accent,
    this.smallValue = false,
  });

  final String label;
  final String value;
  final Color accent;
  final bool smallValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: smallValue ? 118 : 112,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceElevated.withValues(alpha: 0.72),
              AppColors.surfaceMuted.withValues(alpha: 0.6),
            ],
          ),
          border: Border.all(
            color: accent.withValues(alpha: 0.26),
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.07),
              blurRadius: 20,
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
                style: (smallValue
                        ? textTheme.titleMedium
                        : textTheme.titleLarge)
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
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
