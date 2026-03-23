import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/dialogs/delete_confirm_dialog.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../data/models/habit_model.dart';
import '../providers/habits_notifier.dart';
import '../utils/habit_display_strings.dart';
import '../widgets/habit_weekly_dots.dart';
import '../widgets/streak_badge.dart';

class HabitDetailScreen extends ConsumerWidget {
  const HabitDetailScreen({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsNotifierProvider);
    final habit = state.habitById(habitId);
    final notifier = ref.read(habitsNotifierProvider.notifier);
    final now = DateTime.now();

    if (habit == null) {
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
              'This habit is no longer available.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final eligible = habit.appliesToDate(HabitDateUtils.dateOnly(now));
    final done = habit.completedToday(now);

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
              context.showAppSnackBar('Editing habits is coming soon.');
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final ok = await showDeleteConfirmDialog(
                context,
                title: 'Delete habit?',
                message:
                    'This will permanently remove this habit and its history. This cannot be undone.',
              );
              if (!context.mounted || !ok) return;
              final err = await ref
                  .read(habitsNotifierProvider.notifier)
                  .deleteHabit(habitId);
              if (!context.mounted) return;
              if (err != null) {
                context.showAppSnackBar(err, isError: true);
                return;
              }
              context.showAppSnackBar('Habit deleted');
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
            habit.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
          ),
          if (habit.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              habit.description,
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
                  label: 'Today',
                  child: Text(
                    !eligible
                        ? 'Not scheduled today'
                        : done
                            ? 'Completed'
                            : 'Still open',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: done
                              ? AppColors.accentCyan
                              : AppColors.textPrimary,
                        ),
                  ),
                ),
                if (eligible) ...[
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      await notifier.toggleCompleteToday(habit.id);
                      if (!context.mounted) return;
                      final err =
                          ref.read(habitsNotifierProvider).errorMessage;
                      if (err != null) {
                        context.showAppSnackBar(err, isError: true);
                        return;
                      }
                      final nowDone = ref
                          .read(habitsNotifierProvider)
                          .habitById(habit.id)
                          ?.completedToday(now);
                      context.showAppSnackBar(
                        nowDone == true
                            ? 'Nice — habit logged for today'
                            : 'Marked as not done for today',
                      );
                    },
                    icon: Icon(
                      done ? Icons.undo_rounded : Icons.check_rounded,
                      size: 20,
                    ),
                    label: Text(
                      done ? 'Undo today' : 'Mark done for today',
                    ),
                    style: FilledButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      backgroundColor:
                          AppColors.surfaceElevated.withValues(alpha: 0.65),
                    ),
                  ),
                ],
                const Divider(
                  height: AppSpacing.xl,
                  color: AppColors.glassBorderSubtle,
                ),
                _DetailRow(
                  label: 'Streak',
                  child: habit.streakCount > 0
                      ? StreakBadge(
                          days: habit.streakCount,
                          emphasized: habit.streakCount >= 7,
                        )
                      : Text(
                          'Start today — your streak begins with one tap.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                ),
                const Divider(
                  height: AppSpacing.xl,
                  color: AppColors.glassBorderSubtle,
                ),
                _DetailRow(
                  label: 'Category',
                  child: Text(
                    HabitDisplayStrings.category(habit.category),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(
                  label: 'Frequency',
                  child: Text(
                    HabitDisplayStrings.frequency(habit.frequency),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(
                  label: 'Preferred time',
                  child: Text(
                    HabitDisplayStrings.partOfDay(habit.partOfDay),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (habit.targetLabel != null &&
                    habit.targetLabel!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _DetailRow(
                    label: 'Target',
                    child: Text(
                      habit.targetLabel!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
                const Divider(
                  height: AppSpacing.xl,
                  color: AppColors.glassBorderSubtle,
                ),
                Text(
                  'Last 7 days',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                HabitWeeklyDots(habit: habit, now: now),
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
