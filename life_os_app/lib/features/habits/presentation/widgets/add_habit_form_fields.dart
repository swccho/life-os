import 'package:flutter/material.dart';

import '../../../../app/theme/app_input_styles.dart';
import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/habit_model.dart';
import '../utils/habit_display_strings.dart';

class AddHabitFormFields extends StatelessWidget {
  const AddHabitFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.targetController,
    required this.category,
    required this.onCategoryChanged,
    required this.frequency,
    required this.onFrequencyChanged,
    required this.partOfDay,
    required this.onPartOfDayChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController targetController;
  final HabitCategory category;
  final ValueChanged<HabitCategory> onCategoryChanged;
  final HabitFrequency frequency;
  final ValueChanged<HabitFrequency> onFrequencyChanged;
  final HabitPartOfDay partOfDay;
  final ValueChanged<HabitPartOfDay> onPartOfDayChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          decoration: lifeInputDecoration(context, label: 'Habit name'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Add a name';
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: descriptionController,
          minLines: 2,
          maxLines: 4,
          decoration: lifeInputDecoration(
            context,
            label: 'Short description',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: targetController,
          textInputAction: TextInputAction.done,
          decoration: lifeInputDecoration(
            context,
            label: 'Target (optional)',
            prefixIcon: Icon(
              Icons.flag_outlined,
              color: lifeMutedIconColor(context),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: HabitCategory.values.map((c) {
            final on = c == category;
            return ChoiceChip(
              label: Text(HabitDisplayStrings.category(c)),
              selected: on,
              onSelected: (_) => onCategoryChanged(c),
              selectedColor: AppColors.accentCyan.withValues(alpha: 0.28),
              checkmarkColor: AppColors.accentCyan,
              labelStyle: TextStyle(
                color: on ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: on
                    ? AppColors.accentCyan.withValues(alpha: 0.5)
                    : AppColors.glassBorderSubtle,
              ),
              backgroundColor: AppColors.surfaceElevated.withValues(alpha: 0.4),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Frequency',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...HabitFrequency.values.map((f) {
          final on = f == frequency;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onFrequencyChanged(f),
                borderRadius: BorderRadius.circular(AppRadii.md),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    color: on
                        ? AppColors.neonPrimary.withValues(alpha: 0.16)
                        : AppColors.surfaceElevated.withValues(alpha: 0.4),
                    border: Border.all(
                      color: on
                          ? AppColors.neonPrimary.withValues(alpha: 0.45)
                          : AppColors.glassBorderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        on
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        size: 20,
                        color: on
                            ? AppColors.neonPrimary
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              HabitDisplayStrings.frequency(f),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (f == HabitFrequency.custom)
                              Text(
                                'Fine-tune later — for now this behaves like daily.',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Preferred time',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: HabitPartOfDay.values.map((p) {
            final on = p == partOfDay;
            return ChoiceChip(
              label: Text(HabitDisplayStrings.partOfDay(p)),
              selected: on,
              onSelected: (_) => onPartOfDayChanged(p),
              selectedColor: AppColors.accentPurple.withValues(alpha: 0.22),
              checkmarkColor: AppColors.accentPurple,
              labelStyle: TextStyle(
                color: on ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: on
                    ? AppColors.accentPurple.withValues(alpha: 0.45)
                    : AppColors.glassBorderSubtle,
              ),
              backgroundColor: AppColors.surfaceElevated.withValues(alpha: 0.4),
            );
          }).toList(),
        ),
      ],
    );
  }
}
