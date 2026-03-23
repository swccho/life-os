import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/widgets/premium_async_widgets.dart';
import '../../../../shared/widgets/premium_skeleton.dart';
import '../../../mood/presentation/widgets/mood_checkin_card.dart';
import '../providers/journal_notifier.dart';
import '../widgets/journal_empty_state.dart';
import '../widgets/journal_entry_card.dart';
import '../widgets/journal_page_header.dart';
import '../widgets/journal_section_title.dart';
import '../widgets/journal_summary_strip.dart';
import '../widgets/reflection_prompt_card.dart';

class JournalHomeScreen extends ConsumerWidget {
  const JournalHomeScreen({super.key});

  static const String addPath = '/app/journal/add';
  static const String moodHistoryPath = '/app/journal/mood/history';

  static String entryPath(String entryId) => '/app/journal/entry/$entryId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalNotifierProvider);
    final notifier = ref.read(journalNotifierProvider.notifier);
    final now = DateTime.now();
    final stats = state.statsFor(now);
    final entries = state.recentFirst;

    return RefreshIndicator(
      color: AppColors.accentPurple,
      onRefresh: () => notifier.refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (state.errorMessage != null &&
                    state.loadStatus != JournalLoadStatus.loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PremiumInlineErrorBanner(
                      message: state.errorMessage!,
                      onRetry: () {
                        notifier.clearError();
                        notifier.load();
                      },
                    ),
                  ),
                if (state.isLoading && state.entries.isEmpty)
                  const PremiumSkeletonCard(rows: 5)
                else if (state.loadStatus == JournalLoadStatus.error &&
                    state.entries.isEmpty)
                  SizedBox(
                    height: 320,
                    child: PremiumErrorFill(
                      message:
                          state.errorMessage ?? 'Could not load journal.',
                      onRetry: () => notifier.load(),
                    ),
                  )
                else ...[
                  JournalPageHeader(
                    subtitle: 'Reflect on your day',
                    onAddEntry: () => context.push(addPath),
                  ),
                  ReflectionPromptCard(now: now),
                  const SizedBox(height: AppSpacing.lg),
                  JournalSummaryStrip(stats: stats),
                  const SizedBox(height: AppSpacing.lg),
                  MoodCheckInCard(
                    onOpenHistory: () => context.push(moodHistoryPath),
                  ),
                  JournalSectionTitle(title: 'Recent entries'),
                  if (entries.isEmpty)
                    JournalEmptyState(
                      onWriteFirst: () => context.push(addPath),
                    )
                  else
                    ...entries.map(
                      (e) => JournalEntryCard(
                        entry: e,
                        onTap: () => context.push(entryPath(e.id)),
                      ),
                    ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
