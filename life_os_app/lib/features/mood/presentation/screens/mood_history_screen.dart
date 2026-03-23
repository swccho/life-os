import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/dialogs/delete_confirm_dialog.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../providers/mood_notifier.dart';
import '../widgets/mood_history_item.dart';

class MoodHistoryScreen extends ConsumerWidget {
  const MoodHistoryScreen({super.key});

  static const String path = '/app/journal/mood/history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodNotifierProvider);
    final logs = state.recentFirst;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mood history'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.accentCyan,
        onRefresh: () => ref.read(moodNotifierProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
          Text(
            'Recent check-ins',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'A gentle record of how you have been showing up.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (logs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Text(
                'No moods logged yet. Check in from the Journal tab.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...logs.map(
              (e) => MoodHistoryItem(
                entry: e,
                onDelete: () async {
                  final ok = await showDeleteConfirmDialog(
                    context,
                    title: 'Delete mood entry?',
                    message:
                        'This will remove this check-in. This cannot be undone.',
                  );
                  if (!context.mounted || !ok) return;
                  final err = await ref
                      .read(moodNotifierProvider.notifier)
                      .deleteEntry(e.id);
                  if (!context.mounted) return;
                  if (err != null) {
                    context.showAppSnackBar(err, isError: true);
                    return;
                  }
                  context.showAppSnackBar('Mood entry deleted');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
