import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../data/models/habit_model.dart';

/// Last 7 calendar days (today leftmost in UI: reverse order).
class HabitWeeklyDots extends StatelessWidget {
  const HabitWeeklyDots({super.key, required this.habit, required this.now});

  final HabitModel habit;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final today = HabitDateUtils.dateOnly(now);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final d = today.subtract(Duration(days: 6 - i));
        final done = habit.completedDates.contains(HabitDateUtils.toKey(d));
        final w = d.weekday - 1;
        return Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.accentCyan.withValues(alpha: 0.9)
                    : AppColors.surfaceMuted.withValues(alpha: 0.9),
                border: Border.all(
                  color: done
                      ? AppColors.accentCyan.withValues(alpha: 0.4)
                      : AppColors.glassBorderSubtle,
                ),
                boxShadow: done
                    ? [
                        BoxShadow(
                          color: AppColors.accentCyan.withValues(alpha: 0.25),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              labels[w.clamp(0, 6)],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
            ),
          ],
        );
      }),
    );
  }
}
