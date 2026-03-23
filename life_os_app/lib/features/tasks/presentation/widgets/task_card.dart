import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/task_model.dart';
import 'task_category_chip.dart';
import 'task_priority_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.now,
    required this.onTap,
    required this.onToggleComplete,
  });

  final TaskModel task;
  final DateTime now;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dueToday = TaskDateUtils.isDueToday(task, now);
    final completed = task.isCompleted;
    final high = task.priority == TaskPriority.high;

    final borderColor = completed
        ? AppColors.glassBorderSubtle
        : high
            ? AppColors.neonPrimary.withValues(alpha: 0.35)
            : AppColors.glassBorder;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          splashColor: AppColors.neonPrimary.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: completed
                    ? [
                        AppColors.surfaceMuted.withValues(alpha: 0.55),
                        AppColors.surfaceMuted.withValues(alpha: 0.35),
                      ]
                    : [
                        AppColors.glassFillTop.withValues(alpha: 0.2),
                        AppColors.glassFillBottom.withValues(alpha: 0.12),
                      ],
              ),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: completed
                      ? Colors.black.withValues(alpha: 0.25)
                      : AppColors.neonPrimary.withValues(alpha: 0.06),
                  blurRadius: completed ? 12 : 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (high && !completed)
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(AppRadii.lg - 1),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.neonPrimary,
                            AppColors.neonPrimaryDim,
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        high && !completed ? AppSpacing.sm : AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CompleteToggle(
                                completed: completed,
                                onTap: onToggleComplete,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        decoration: completed
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor:
                                            AppColors.textMuted.withValues(
                                          alpha: 0.8,
                                        ),
                                        color: completed
                                            ? AppColors.textMuted
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (task.description.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: completed
                                              ? AppColors.textDisabled
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TaskCategoryChip(category: task.category),
                              TaskPriorityBadge(priority: task.priority),
                              if (task.dueDate != null)
                                _DueMeta(
                                  due: task.dueDate!,
                                  dueToday: dueToday,
                                  muted: completed,
                                ),
                            ],
                          ),
                        ],
                      ),
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

class _CompleteToggle extends StatelessWidget {
  const _CompleteToggle({
    required this.completed,
    required this.onTap,
  });

  final bool completed;
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
            duration: const Duration(milliseconds: 180),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: completed
                    ? AppColors.success
                    : AppColors.glassBorder,
                width: 2,
              ),
              color: completed
                  ? AppColors.success.withValues(alpha: 0.2)
                  : Colors.transparent,
              boxShadow: completed
                  ? [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.25),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: completed
                  ? const Icon(
                      Icons.check_rounded,
                      key: ValueKey('done'),
                      size: 16,
                      color: AppColors.success,
                    )
                  : const SizedBox(
                      key: ValueKey('open'),
                      width: 16,
                      height: 16,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DueMeta extends StatelessWidget {
  const _DueMeta({
    required this.due,
    required this.dueToday,
    required this.muted,
  });

  final DateTime due;
  final bool dueToday;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(due);
    final date = DateFormat.MMMd().format(due);

    final color = muted
        ? AppColors.textDisabled
        : dueToday
            ? AppColors.accentCyan
            : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        color: dueToday && !muted
            ? AppColors.accentCyan.withValues(alpha: 0.12)
            : AppColors.surfaceElevated.withValues(alpha: 0.4),
        border: Border.all(
          color: dueToday && !muted
              ? AppColors.accentCyan.withValues(alpha: 0.35)
              : AppColors.glassBorderSubtle,
        ),
      ),
      child: Text(
        dueToday ? 'Today · $time' : '$date · $time',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
