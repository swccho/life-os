import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../data/models/habit_model.dart';

class HabitsNeedsAttentionRow extends StatelessWidget {
  const HabitsNeedsAttentionRow({
    super.key,
    required this.habits,
    required this.onOpen,
  });

  final List<HabitModel> habits;
  final void Function(HabitModel h) onOpen;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Still open today',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppGlassCard(
          elevated: false,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gentle nudge — no pressure, just progress.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...habits.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onOpen(h),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                          horizontal: AppSpacing.xs,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                h.title,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
