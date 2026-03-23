import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../../../shared/widgets/premium_async_widgets.dart';
import '../../../../shared/widgets/premium_skeleton.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/task_page_header.dart';
import '../widgets/task_summary_strip.dart';
import '../widgets/task_today_focus_card.dart';
import '../widgets/tasks_empty_state.dart';
import '../widgets/tasks_section_title.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  static const String addPath = '/app/tasks/add';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksNotifierProvider);
    final notifier = ref.read(tasksNotifierProvider.notifier);
    final now = DateTime.now();
    final stats = state.statsFor(now);
    final filtered = state.filtered(now);
    final focus = state.todayFocusTask(now);

    String emptyTitle;
    String emptyMessage;
    switch (state.filter) {
      case TaskViewFilter.completed:
        emptyTitle = 'No completed tasks';
        emptyMessage =
            'Finish something small today — you will see it shine here.';
        break;
      case TaskViewFilter.today:
        emptyTitle = 'Nothing due today';
        emptyMessage =
            'Enjoy the calm, or add something meaningful for this evening.';
        break;
      case TaskViewFilter.upcoming:
        emptyTitle = 'No upcoming deadlines';
        emptyMessage =
            'You are caught up ahead. Add a task with a future due date.';
        break;
      case TaskViewFilter.all:
        emptyTitle = 'No tasks yet';
        emptyMessage =
            'Start with one clear priority — LifeOS will grow with you.';
        break;
    }

    return RefreshIndicator(
      color: AppColors.neonPrimary,
      onRefresh: () => notifier.refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state.errorMessage != null &&
              state.loadStatus != TasksLoadStatus.loading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  0,
                ),
                child: PremiumInlineErrorBanner(
                  message: state.errorMessage!,
                  onRetry: () {
                    notifier.clearError();
                    notifier.load();
                  },
                ),
              ),
            ),
          if (state.isLoading && state.tasks.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const PremiumSkeletonListRow(),
                  childCount: 6,
                ),
              ),
            )
          else if (state.loadStatus == TasksLoadStatus.error &&
              state.tasks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: PremiumErrorFill(
                message: state.errorMessage ?? 'Could not load tasks.',
                onRetry: () => notifier.load(),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  TaskPageHeader(
                    subtitle: 'Organize your priorities',
                    onAddTask: () => context.push(addPath),
                  ),
                  TaskSummaryStrip(stats: stats),
                  const SizedBox(height: AppSpacing.lg),
                  TaskFilterBar(
                    selected: state.filter,
                    onChanged: notifier.setFilter,
                  ),
                  if (focus != null &&
                      state.filter == TaskViewFilter.all) ...[
                    const SizedBox(height: AppSpacing.lg),
                    TaskTodayFocusCard(
                      task: focus,
                      onOpen: () => context.push(
                        '/app/tasks/task/${focus.id}',
                      ),
                    ),
                  ],
                  TasksSectionTitle(
                    title: state.filter == TaskViewFilter.all
                        ? 'Your tasks'
                        : '${_filterHeading(state.filter)} tasks',
                  ),
                  if (filtered.isEmpty)
                    TasksEmptyState(
                      title: emptyTitle,
                      message: emptyMessage,
                      onAddTask: () => context.push(addPath),
                    )
                  else
                    ...filtered.map(
                      (task) => TaskCard(
                        task: task,
                        now: now,
                        onTap: () => context.push('/app/tasks/task/${task.id}'),
                        onToggleComplete: () async {
                          final prev = task.isCompleted;
                          await notifier.toggleComplete(task.id);
                          if (!context.mounted) return;
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
                      ),
                    ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

String _filterHeading(TaskViewFilter f) {
  switch (f) {
    case TaskViewFilter.all:
      return 'All';
    case TaskViewFilter.today:
      return 'Today';
    case TaskViewFilter.upcoming:
      return 'Upcoming';
    case TaskViewFilter.completed:
      return 'Completed';
  }
}
