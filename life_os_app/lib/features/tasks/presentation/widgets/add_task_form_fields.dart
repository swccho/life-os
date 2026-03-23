import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_input_styles.dart';
import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/task_model.dart';
import '../utils/task_display_strings.dart';

class AddTaskFormFields extends StatelessWidget {
  const AddTaskFormFields({
    super.key,
    required this.titleController,
    required this.noteController,
    required this.selectedDue,
    required this.onPickDue,
    required this.onClearDue,
    required this.priority,
    required this.onPriorityChanged,
    required this.category,
    required this.onCategoryChanged,
  });

  final TextEditingController titleController;
  final TextEditingController noteController;
  final DateTime? selectedDue;
  final VoidCallback onPickDue;
  final VoidCallback onClearDue;
  final TaskPriority priority;
  final ValueChanged<TaskPriority> onPriorityChanged;
  final TaskCategory category;
  final ValueChanged<TaskCategory> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          decoration: lifeInputDecoration(context, label: 'Title'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Add a title';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: noteController,
          minLines: 2,
          maxLines: 4,
          decoration: lifeInputDecoration(
            context,
            label: 'Short note',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Due',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickDue,
                icon: const Icon(Icons.event_rounded, size: 20),
                label: Text(
                  selectedDue == null
                      ? 'Pick date'
                      : DateFormat.yMMMd().add_jm().format(selectedDue!),
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.glassBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                ),
              ),
            ),
            if (selectedDue != null) ...[
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: onClearDue,
                tooltip: 'Clear due date',
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _PriorityRow(
          value: priority,
          onChanged: onPriorityChanged,
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
          children: TaskCategory.values.map((c) {
            final on = c == category;
            return ChoiceChip(
              label: Text(TaskDisplayStrings.category(c)),
              selected: on,
              onSelected: (_) => onCategoryChanged(c),
              selectedColor: AppColors.neonPrimary.withValues(alpha: 0.28),
              checkmarkColor: AppColors.neonPrimary,
              labelStyle: TextStyle(
                color: on ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: on
                    ? AppColors.neonPrimary.withValues(alpha: 0.5)
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

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({
    required this.value,
    required this.onChanged,
  });

  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((p) {
        final on = p == value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: p != TaskPriority.high ? AppSpacing.xs : 0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChanged(p),
                borderRadius: BorderRadius.circular(AppRadii.md),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    color: on
                        ? AppColors.neonPrimary.withValues(alpha: 0.2)
                        : AppColors.surfaceElevated.withValues(alpha: 0.45),
                    border: Border.all(
                      color: on
                          ? AppColors.neonPrimary.withValues(alpha: 0.55)
                          : AppColors.glassBorderSubtle,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      TaskDisplayStrings.priority(p),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                            color: on
                                ? AppColors.neonPrimary
                                : AppColors.textSecondary,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
