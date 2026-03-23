import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/dashboard_preview_data.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../utils/dashboard_greeting.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
    required this.onOpenProfile,
    required this.onOpenNotifications,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final user = auth.user;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final greeting = DashboardGreeting.forTime(now);
    final name = DashboardGreeting.firstNameOrFallback(user?.name);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $name',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DashboardPreviewData.subtitles[now.day %
                      DashboardPreviewData.subtitles.length],
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onOpenNotifications,
            tooltip: 'Notifications',
            style: IconButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onOpenProfile,
              customBorder: const CircleBorder(),
              child: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonPrimary.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPrimary.withValues(alpha: 0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Text(
                    initial,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.neonPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
