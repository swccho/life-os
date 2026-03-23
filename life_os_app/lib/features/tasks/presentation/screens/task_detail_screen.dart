import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/dialogs/delete_confirm_dialog.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_category_chip.dart';
import '../widgets/task_priority_badge.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksNotifierProvider);
    final task = state.taskById(taskId);
    final notifier = ref.read(tasksNotifierProvider.notifier);

    if (task == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'This task is no longer available.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.showAppSnackBar('Editing tasks is coming soon.');
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final ok = await showDeleteConfirmDialog(
                context,
                title: 'Delete task?',
                message:
                    'This will permanently remove this task. This cannot be undone.',
              );
              if (!context.mounted || !ok) return;
              final err = await ref
                  .read(tasksNotifierProvider.notifier)
                  .deleteTask(taskId);
              if (!context.mounted) return;
              if (err != null) {
                context.showAppSnackBar(err, isError: true);
                return;
              }
              context.showAppSnackBar('Task deleted');
              context.pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text(
            task.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: AppColors.textMuted,
                  color: task.isCompleted
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                ),
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppGlassCard(
            elevated: true,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  label: 'Status',
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(
                          task.isCompleted ? 'Completed' : 'Pending',
                        ),
                        selected: task.isCompleted,
                        onSelected: (_) async {
                          final prev = task.isCompleted;
                          await notifier.toggleComplete(task.id);
                          if (!context.mounted) return;
                          final err =
                              ref.read(tasksNotifierProvider).errorMessage;
                          if (err != null) {
                            context.showAppSnackBar(err, isError: true);
                            return;
                          }
                          final next = ref
                                  .read(tasksNotifierProvider)
                                  .taskById(task.id)
                                  ?.isCompleted ??
                              prev;
                          if (next != prev) {
                            context.showAppSnackBar(
                              next ? 'Task completed' : 'Task reopened',
                            );
                          }
                        },
                        selectedColor:
                            AppColors.success.withValues(alpha: 0.22),
                        checkmarkColor: AppColors.success,
                        labelStyle: TextStyle(
                          color: task.isCompleted
                              ? AppColors.success
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: AppSpacing.xl, color: AppColors.glassBorderSubtle),
                _DetailRow(
                  label: 'Due',
                  child: Text(
                    task.dueDate == null
                        ? 'No due date'
                        : DateFormat.yMMMEd()
                            .add_jm()
                            .format(task.dueDate!),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TaskDateUtils.isDueToday(task, DateTime.now())
                              ? AppColors.accentCyan
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const Divider(height: AppSpacing.xl, color: AppColors.glassBorderSubtle),
                _DetailRow(
                  label: 'Priority',
                  child: TaskPriorityBadge(priority: task.priority),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(
                  label: 'Category',
                  child: TaskCategoryChip(category: task.category),
                ),
                const Divider(height: AppSpacing.xl, color: AppColors.glassBorderSubtle),
                _DetailRow(
                  label: 'Created',
                  child: Text(
                    DateFormat.yMMMd().add_jm().format(task.createdAt),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
