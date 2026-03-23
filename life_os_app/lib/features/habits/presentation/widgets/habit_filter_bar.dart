import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../providers/habits_notifier.dart';
import '../utils/habit_display_strings.dart';

class HabitFilterBar extends StatelessWidget {
  const HabitFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HabitViewFilter selected;
  final ValueChanged<HabitViewFilter> onChanged;

  static const _filters = HabitViewFilter.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (context, index) {
              final f = _filters[index];
              final isOn = f == selected;
              return _FilterPill(
                label: HabitDisplayStrings.filter(f),
                selected: isOn,
                onTap: () => onChanged(f),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        AppColors.accentCyan.withValues(alpha: 0.28),
                        AppColors.neonPrimary.withValues(alpha: 0.18),
                      ],
                    )
                  : null,
              color: selected
                  ? null
                  : AppColors.surfaceElevated.withValues(alpha: 0.5),
              border: Border.all(
                color: selected
                    ? AppColors.accentCyan.withValues(alpha: 0.5)
                    : AppColors.glassBorderSubtle,
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color:
                    selected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
