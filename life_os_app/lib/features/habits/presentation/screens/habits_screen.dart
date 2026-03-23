import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../../../shared/widgets/premium_async_widgets.dart';
import '../../../../shared/widgets/premium_skeleton.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../providers/habits_notifier.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_filter_bar.dart';
import '../widgets/habit_page_header.dart';
import '../widgets/habits_empty_state.dart';
import '../widgets/habits_needs_attention_row.dart';
import '../widgets/habits_section_title.dart';
import '../widgets/habits_summary_strip.dart';
import '../widgets/habits_today_progress_card.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  static const String addPath = '/app/habits/add';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsNotifierProvider);
    final notifier = ref.read(habitsNotifierProvider.notifier);
    final now = DateTime.now();
    final stats = state.statsFor(now);
    final filtered = state.filtered(now);
    final attention = state.needsAttention(now);

    String emptyTitle;
    String emptyMessage;
    switch (state.filter) {
      case HabitViewFilter.completed:
        emptyTitle = 'Nothing completed yet today';
        emptyMessage =
            'Check in when you finish a habit — your summary will light up.';
        break;
      case HabitViewFilter.missed:
        emptyTitle = 'All caught up for today';
        emptyMessage =
            'Every habit scheduled for today is done. Enjoy the win.';
        break;
      case HabitViewFilter.today:
        emptyTitle = 'Nothing scheduled today';
        emptyMessage =
            'Try another view or add a daily habit to anchor your rhythm.';
        break;
      case HabitViewFilter.all:
        emptyTitle = 'No habits yet';
        emptyMessage =
            'Choose one ritual you can repeat — consistency beats intensity.';
        break;
    }

    final showCatchUp = state.filter == HabitViewFilter.all &&
        stats.eligibleToday > 0 &&
        stats.completedToday == stats.eligibleToday;

    return RefreshIndicator(
      color: AppColors.accentCyan,
      onRefresh: () => notifier.refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state.errorMessage != null &&
              state.loadStatus != HabitsLoadStatus.loading)
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
          if (state.isLoading && state.habits.isEmpty)
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
          else if (state.loadStatus == HabitsLoadStatus.error &&
              state.habits.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: PremiumErrorFill(
                message: state.errorMessage ?? 'Could not load habits.',
                onRetry: () => notifier.load(),
              ),
            )
          else if (state.habits.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  HabitPageHeader(
                    subtitle: 'Build consistency every day',
                    onAddHabit: () => context.push(addPath),
                  ),
                  HabitsEmptyState(
                    title: emptyTitle,
                    message: emptyMessage,
                    onCreate: () => context.push(addPath),
                  ),
                ]),
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
                  HabitPageHeader(
                    subtitle: 'Small actions, big progress',
                    onAddHabit: () => context.push(addPath),
                  ),
                  HabitsSummaryStrip(stats: stats),
                  const SizedBox(height: AppSpacing.lg),
                  HabitsTodayProgressCard(stats: stats),
                  const SizedBox(height: AppSpacing.lg),
                  HabitFilterBar(
                    selected: state.filter,
                    onChanged: notifier.setFilter,
                  ),
                  if (showCatchUp) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppGlassCard(
                      elevated: false,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            color: AppColors.success.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Today is fully checked in — rest or stack a bonus round.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state.filter == HabitViewFilter.all && attention.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: HabitsNeedsAttentionRow(
                        habits: attention,
                        onOpen: (h) =>
                            context.push('/app/habits/habit/${h.id}'),
                      ),
                    ),
                  HabitsSectionTitle(
                    title: _listTitle(state.filter),
                  ),
                  if (filtered.isEmpty)
                    HabitsEmptyState(
                      title: emptyTitle,
                      message: emptyMessage,
                      onCreate: state.filter == HabitViewFilter.all
                          ? () => context.push(addPath)
                          : null,
                      actionLabel: 'Create your first habit',
                    )
                  else
                    ...filtered.map(
                      (h) => HabitCard(
                        habit: h,
                        now: now,
                        onTap: () => context.push('/app/habits/habit/${h.id}'),
                        onToggleToday: () async {
                          await notifier.toggleCompleteToday(h.id);
                          if (!context.mounted) return;
                          final err =
                              ref.read(habitsNotifierProvider).errorMessage;
                          if (err != null) {
                            context.showAppSnackBar(err, isError: true);
                            return;
                          }
                          final done = ref
                              .read(habitsNotifierProvider)
                              .habitById(h.id)
                              ?.completedToday(now);
                          context.showAppSnackBar(
                            done == true
                                ? 'Habit logged for today'
                                : 'Updated for today',
                          );
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

String _listTitle(HabitViewFilter f) {
  switch (f) {
    case HabitViewFilter.all:
      return 'Your habits';
    case HabitViewFilter.today:
      return 'Due today';
    case HabitViewFilter.completed:
      return 'Completed today';
    case HabitViewFilter.missed:
      return 'Open for today';
  }
}
