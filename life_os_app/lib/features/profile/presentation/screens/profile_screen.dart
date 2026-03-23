import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/widgets/premium_async_widgets.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../dashboard/presentation/providers/dashboard_notifier.dart';
import '../../../shell/presentation/shell_branch_indices.dart';
import '../utils/profile_consistency_score.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static void _goBranch(BuildContext context, int index) {
    final shell = StatefulNavigationShell.of(context);
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final user = auth.user;
    final dash = ref.watch(dashboardNotifierProvider);
    final summary = dash.summary;
    final loading = dash.isLoading;
    final err = dash.errorMessage;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    if (user == null) {
      return const Center(child: Text('Sign in to view your profile.'));
    }

    final initials = initialsFromName(user.name);
    final score = summary != null ? profileConsistencyScore(summary) : null;

    return RefreshIndicator(
      color: AppColors.neonPrimary,
      onRefresh: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
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
                Text('Profile', style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your hub for identity and preferences.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (err != null && !loading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PremiumInlineErrorBanner(
                      message: err,
                      onRetry: () =>
                          ref.read(dashboardNotifierProvider.notifier).load(),
                    ),
                  ),
                AppGlassCard(
                  elevated: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            color: scheme.primaryContainer
                                .withValues(alpha: 0.35),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () =>
                                  context.push('/app/profile/edit'),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  initials,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: scheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  user.email,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                if (user.bio != null &&
                                    user.bio!.trim().isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    user.bio!,
                                    style: textTheme.bodyMedium,
                                  ),
                                ] else ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Add a short bio in Edit profile.',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              context.push('/app/profile/edit'),
                          child: const Text('Edit profile'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Your stats', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                if (loading || summary == null)
                  const AppGlassCard(
                    child: SizedBox(
                      height: 120,
                      child: PremiumLoadingCenter(),
                    ),
                  )
                else
                  AppGlassCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatBlock(
                                label: 'Tasks done',
                                value: '${summary.completedTasks}',
                              ),
                            ),
                            Expanded(
                              child: _StatBlock(
                                label: 'Habits today',
                                value:
                                    '${summary.todayHabitLogsCount}/${summary.activeHabitsCount > 0 ? summary.activeHabitsCount : '—'}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _StatBlock(
                                label: 'Journal entries',
                                value: '${summary.journalEntriesCount}',
                              ),
                            ),
                            Expanded(
                              child: _StatBlock(
                                label: 'Consistency',
                                value: score != null ? '$score' : '—',
                                hint: 'Heuristic from your activity',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Text('Activity', style: textTheme.titleMedium),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          _goBranch(context, AppShellBranchIndices.dashboard),
                      child: const Text('Dashboard'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (loading || summary == null)
                  const AppGlassCard(
                    child: SizedBox(
                      height: 100,
                      child: PremiumLoadingCenter(),
                    ),
                  )
                else
                  AppGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ActivityRow(
                          icon: Icons.auto_stories_outlined,
                          title: 'Last journal',
                          subtitle: summary.latestJournalEntry != null
                              ? summary.latestJournalEntry!.title
                              : 'No entries yet',
                          onTap: summary.latestJournalEntry != null
                              ? () => context.push(
                                    '/app/journal/entry/${summary.latestJournalEntry!.id}',
                                  )
                              : () => _goBranch(
                                    context,
                                    AppShellBranchIndices.journal,
                                  ),
                        ),
                        Divider(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                        _ActivityRow(
                          icon: Icons.bolt_outlined,
                          title: 'Last habit log',
                          subtitle: summary.latestHabitActivity != null
                              ? '${summary.latestHabitActivity!.habitTitle} · ${_formatDate(summary.latestHabitActivity!.loggedDate)}'
                              : 'Log a habit to see it here',
                          onTap: summary.latestHabitActivity != null
                              ? () => context.push(
                                    '/app/habits/habit/${summary.latestHabitActivity!.habitId}',
                                  )
                              : () => _goBranch(
                                    context,
                                    AppShellBranchIndices.habits,
                                  ),
                        ),
                        Divider(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                        _ActivityRow(
                          icon: Icons.task_alt_outlined,
                          title: 'Recent tasks',
                          subtitle: summary.recentTasks.isEmpty
                              ? 'Nothing recent'
                              : '${summary.recentTasks.length} updates',
                          onTap: () {
                            _goBranch(context, AppShellBranchIndices.tasks);
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                Text('Shortcuts', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                AppGlassCard(
                  child: Column(
                    children: [
                      _ProfileActionTile(
                        icon: Icons.edit_outlined,
                        label: 'Edit profile',
                        onTap: () => context.push('/app/profile/edit'),
                      ),
                      Divider(
                        height: 1,
                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      _ProfileActionTile(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () => context.push('/app/profile/settings'),
                      ),
                      Divider(
                        height: 1,
                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      _ProfileActionTile(
                        icon: Icons.logout_rounded,
                        label: 'Sign out',
                        destructive: true,
                        onTap: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Sign out?'),
                              content: const Text(
                                'You will need to sign in again to use LifeOS.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Sign out'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .logout();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(String ymd) {
    try {
      final d = DateTime.parse(ymd);
      return DateFormat.MMMd().format(d);
    } catch (_) {
      return ymd;
    }
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.label,
    required this.value,
    this.hint,
  });

  final String label;
  final String value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neonPrimary,
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (hint != null)
            Text(
              hint!,
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: scheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = destructive ? scheme.error : scheme.onSurface;
    return ListTile(
      leading: Icon(icon, color: destructive ? scheme.error : scheme.primary),
      title: Text(label, style: TextStyle(color: color)),
      trailing: Icon(Icons.chevron_right_rounded, color: color),
      onTap: onTap,
    );
  }
}
