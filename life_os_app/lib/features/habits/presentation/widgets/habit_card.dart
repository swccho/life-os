import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/habit_model.dart';
import '../utils/habit_display_strings.dart';
import 'streak_badge.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.now,
    required this.onTap,
    required this.onToggleToday,
  });

  final HabitModel habit;
  final DateTime now;
  final VoidCallback onTap;
  final VoidCallback onToggleToday;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final eligible = habit.appliesToDate(HabitDateUtils.dateOnly(now));
    final done = habit.completedToday(now);
    final missed = eligible && !done;
    final strongStreak = habit.streakCount >= 7;

    final borderColor = done
        ? AppColors.accentCyan.withValues(alpha: 0.45)
        : strongStreak
            ? AppColors.accentPink.withValues(alpha: 0.28)
            : missed
                ? AppColors.glassBorderSubtle
                : AppColors.glassBorder;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          splashColor: AppColors.accentCyan.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: done
                    ? [
                        AppColors.accentCyan.withValues(alpha: 0.12),
                        AppColors.surfaceElevated.withValues(alpha: 0.45),
                      ]
                    : missed
                        ? [
                            AppColors.surfaceMuted.withValues(alpha: 0.4),
                            AppColors.surfaceMuted.withValues(alpha: 0.28),
                          ]
                        : [
                            AppColors.glassFillTop.withValues(alpha: 0.18),
                            AppColors.glassFillBottom.withValues(alpha: 0.1),
                          ],
              ),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: done
                      ? AppColors.accentCyan.withValues(alpha: 0.12)
                      : AppColors.neonPrimary.withValues(alpha: 0.05),
                  blurRadius: done ? 24 : 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompleteControl(
                    done: done,
                    onTap: onToggleToday,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: missed
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (habit.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: missed
                                  ? AppColors.textDisabled
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaChip(
                              text: HabitDisplayStrings.category(habit.category),
                            ),
                            _MetaChip(
                              text: HabitDisplayStrings.frequency(habit.frequency),
                            ),
                            _MetaChip(
                              text: HabitDisplayStrings.partOfDay(habit.partOfDay),
                            ),
                            if (habit.targetLabel != null &&
                                habit.targetLabel!.isNotEmpty)
                              _MetaChip(text: habit.targetLabel!),
                            if (habit.streakCount > 0)
                              StreakBadge(
                                days: habit.streakCount,
                                emphasized: strongStreak,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        color: AppColors.surfaceElevated.withValues(alpha: 0.45),
        border: Border.all(color: AppColors.glassBorderSubtle),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _CompleteControl extends StatelessWidget {
  const _CompleteControl({
    required this.done,
    required this.onTap,
  });

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: done
                    ? AppColors.accentCyan
                    : AppColors.glassBorder,
                width: 2.5,
              ),
              color: done
                  ? AppColors.accentCyan.withValues(alpha: 0.18)
                  : AppColors.surfaceElevated.withValues(alpha: 0.35),
              boxShadow: done
                  ? [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.35),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
            ),
            child: done
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.accentCyan,
                    size: 24,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
