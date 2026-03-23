import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../data/models/task_model.dart';
import '../utils/task_display_strings.dart';

class TaskCategoryChip extends StatelessWidget {
  const TaskCategoryChip({super.key, required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        color: AppColors.accentPurple.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.accentPurple.withValues(alpha: 0.28),
        ),
      ),
      child: Text(
        TaskDisplayStrings.category(category),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
