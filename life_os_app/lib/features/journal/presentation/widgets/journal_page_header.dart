import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/extensions/context_snackbars.dart';

class JournalPageHeader extends StatelessWidget {
  const JournalPageHeader({
    super.key,
    required this.subtitle,
    this.onAddEntry,
  });

  final String subtitle;
  final VoidCallback? onAddEntry;

  void _comingSoon(BuildContext context, String label) {
    context.showAppSnackBar('$label is coming soon.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = AppColors.accentPurple;

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
                  'Journal',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _comingSoon(context, 'Search'),
            tooltip: 'Search',
            style: IconButton.styleFrom(foregroundColor: AppColors.textMuted),
            icon: const Icon(Icons.search_rounded, size: 24),
          ),
          IconButton(
            onPressed: () => _comingSoon(context, 'Calendar'),
            tooltip: 'Calendar',
            style: IconButton.styleFrom(foregroundColor: AppColors.textMuted),
            icon: const Icon(Icons.calendar_month_outlined, size: 24),
          ),
          if (onAddEntry != null)
            IconButton(
              onPressed: onAddEntry,
              tooltip: 'New entry',
              style: IconButton.styleFrom(foregroundColor: accent),
              icon: const Icon(Icons.edit_note_rounded, size: 28),
            ),
        ],
      ),
    );
  }
}
