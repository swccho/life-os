import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../providers/tasks_notifier.dart';
import '../utils/task_display_strings.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaskViewFilter selected;
  final ValueChanged<TaskViewFilter> onChanged;

  static const _filters = TaskViewFilter.values;

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
                label: TaskDisplayStrings.filter(f),
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
                        AppColors.neonPrimary.withValues(alpha: 0.35),
                        AppColors.neonPrimaryDim.withValues(alpha: 0.22),
                      ],
                    )
                  : null,
              color: selected
                  ? null
                  : AppColors.surfaceElevated.withValues(alpha: 0.5),
              border: Border.all(
                color: selected
                    ? AppColors.neonPrimary.withValues(alpha: 0.55)
                    : AppColors.glassBorderSubtle,
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.neonPrimary.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
