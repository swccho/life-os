import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/tokens/app_colors.dart';
import '../../../app/theme/tokens/app_spacing.dart';
import '../../../shared/extensions/context_snackbars.dart';
import '../../../shared/widgets/premium_async_widgets.dart';
import '../../shell/presentation/shell_branch_indices.dart';
import 'providers/dashboard_notifier.dart';
import 'widgets/dashboard_activity_section.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_hero_card.dart';
import 'widgets/dashboard_quick_actions_section.dart';
import 'widgets/dashboard_stats_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static void _goBranch(BuildContext context, int index) {
    final shell = StatefulNavigationShell.of(context);
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }

  static void _snack(BuildContext context, String message) {
    context.showAppSnackBar(message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dash = ref.watch(dashboardNotifierProvider);
    final dashNotifier = ref.read(dashboardNotifierProvider.notifier);
    final summary = dash.summary;
    final loading = dash.isLoading;
    final err = dash.errorMessage;

    return RefreshIndicator(
      color: AppColors.neonPrimary,
      onRefresh: () => dashNotifier.refresh(),
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
                DashboardHeader(
                  onOpenProfile: () =>
                      _goBranch(context, AppShellBranchIndices.profile),
                  onOpenNotifications: () => _snack(
                    context,
                    'Notifications are coming soon.',
                  ),
                ),
                if (err != null && !loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PremiumInlineErrorBanner(
                      message: err,
                      onRetry: () => dashNotifier.load(),
                    ),
                  ),
                DashboardHeroCard(
                  summary: summary,
                  isLoading: loading,
                ),
                const SizedBox(height: AppSpacing.xl),
                DashboardQuickActionsSection(
                  onAddTask: () {
                    _goBranch(context, AppShellBranchIndices.tasks);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      context.push('/app/tasks/add');
                    });
                  },
                  onLogHabit: () {
                    _goBranch(context, AppShellBranchIndices.habits);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      context.push('/app/habits/add');
                    });
                  },
                  onWriteJournal: () =>
                      _goBranch(context, AppShellBranchIndices.journal),
                  onUpdateMood: () =>
                      _goBranch(context, AppShellBranchIndices.journal),
                ),
                const SizedBox(height: AppSpacing.xl),
                DashboardStatsSection(
                  summary: summary,
                  isLoading: loading,
                ),
                const SizedBox(height: AppSpacing.xl),
                DashboardActivitySection(
                  summary: summary,
                  isLoading: loading,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
