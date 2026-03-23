import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../providers/habits_notifier.dart';

class HabitsTodayProgressCard extends StatelessWidget {
  const HabitsTodayProgressCard({super.key, required this.stats});

  final HabitSummaryStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final p = stats.todayProgress.clamp(0.0, 1.0);
    final done = stats.completedToday;
    final total = stats.eligibleToday;
    final line = _motivationLine(p, done, total);

    return AppGlassCard(
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 104,
                  height: 104,
                  child: CircularProgressIndicator(
                    value: total == 0 ? 0 : p,
                    strokeWidth: 7,
                    backgroundColor:
                        AppColors.surfaceMuted.withValues(alpha: 0.8),
                    color: AppColors.accentCyan,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      total == 0 ? '—' : '$done',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      total == 0 ? '' : 'of $total',
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  total == 0
                      ? 'Add a habit to start tracking'
                      : '$done of $total habits completed today',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : p,
                    minHeight: 6,
                    backgroundColor:
                        AppColors.surfaceMuted.withValues(alpha: 0.9),
                    color: AppColors.neonPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  line,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _motivationLine(double p, int done, int total) {
  if (total == 0) return 'Small actions add up — start with one ritual.';
  if (p >= 1) return 'You showed up for yourself today. Carry that energy.';
  if (p >= 0.5) return 'Strong momentum — keep the streak alive.';
  if (done > 0) return 'Nice start — one more win before you close the day.';
  return 'Your future self will thank you for starting now.';
}
