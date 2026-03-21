import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens/app_spacing.dart';
import '../../../core/widgets/app_glass_card.dart';
import '../../../core/widgets/app_screen_background.dart';
import '../../auth/presentation/providers/auth_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final user = auth.user;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final topContentPadding = kToolbarHeight + AppSpacing.md;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          if (auth.isBusy)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: AppSpacing.md),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Log out',
              onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            ),
        ],
      ),
      body: AppScreenBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            topContentPadding,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: AppGlassCard(
            elevated: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome${user != null ? ', ${user.name}' : ''}',
                  style: textTheme.headlineSmall,
                ),
                if (user != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    user.email,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your dashboard will appear here.',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
