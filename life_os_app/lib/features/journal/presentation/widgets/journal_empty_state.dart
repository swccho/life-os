import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

class JournalEmptyState extends StatelessWidget {
  const JournalEmptyState({
    super.key,
    required this.onWriteFirst,
  });

  final VoidCallback onWriteFirst;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated.withValues(alpha: 0.55),
            AppColors.surfaceMuted.withValues(alpha: 0.45),
          ],
        ),
        border: Border.all(color: AppColors.glassBorderSubtle),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 48,
              color: AppColors.accentCyan.withValues(alpha: 0.75),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your journal is a quiet room',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Capture thoughts without judgment. One short entry is a beautiful start.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onWriteFirst,
              icon: const Icon(Icons.edit_note_rounded, size: 22),
              label: const Text('Write your first entry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentPurple.withValues(alpha: 0.85),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
