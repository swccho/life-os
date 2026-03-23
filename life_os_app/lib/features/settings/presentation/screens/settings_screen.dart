import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((p) {
      if (mounted) setState(() => _packageInfo = p);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncSettings = ref.watch(settingsNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load settings')),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Text('App', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            AppGlassCard(
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Match system theme'),
                    subtitle: const Text(
                      'LifeOS stays dark for now; this stores your preference.',
                    ),
                    value: data.useSystemTheme,
                    onChanged: (v) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setUseSystemTheme(v),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Accent color'),
                    subtitle: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(kAccentPresets.length, (i) {
                        final c = kAccentPresets[i];
                        final selected = data.accentPresetIndex == i;
                        return InkWell(
                          onTap: () => ref
                              .read(settingsNotifierProvider.notifier)
                              .setAccentPreset(i),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c,
                              border: Border.all(
                                color: selected
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifications'),
                    subtitle: const Text('UI only — no push yet'),
                    value: data.notificationsEnabled,
                    onChanged: (v) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setNotificationsEnabled(v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Productivity', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            AppGlassCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Default task view'),
                    subtitle: const Text('When you open the Tasks tab'),
                    trailing: DropdownButton<int>(
                      value: data.defaultTaskViewIndex.clamp(0, 1),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('All')),
                        DropdownMenuItem(value: 1, child: Text('Today')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(settingsNotifierProvider.notifier)
                              .setDefaultTaskViewIndex(v);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Habit reminders'),
                    subtitle: const Text('UI only'),
                    value: data.habitRemindersEnabled,
                    onChanged: (v) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setHabitRemindersEnabled(v),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Journaling reminder'),
                    subtitle: const Text('UI only'),
                    value: data.journalRemindersEnabled,
                    onChanged: (v) => ref
                        .read(settingsNotifierProvider.notifier)
                        .setJournalRemindersEnabled(v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Account', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            AppGlassCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock_outline_rounded),
                    title: const Text('Change password'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push('/app/profile/change-password'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Sign out?'),
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
                        await ref.read(authNotifierProvider.notifier).logout();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('About', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            AppGlassCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Version'),
                    subtitle: Text(
                      _packageInfo == null
                          ? '…'
                          : '${_packageInfo!.version} (${_packageInfo!.buildNumber})',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('About LifeOS'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/app/profile/about'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Privacy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/app/profile/privacy'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Terms'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/app/profile/terms'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: () => context.showAppSnackBar(
                'Thanks — feedback channels are coming soon.',
              ),
              child: const Text('Send feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
