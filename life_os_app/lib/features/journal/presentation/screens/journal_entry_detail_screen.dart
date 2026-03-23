import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/dialogs/delete_confirm_dialog.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../../mood/data/models/mood_level.dart';
import '../providers/journal_notifier.dart';

class JournalEntryDetailScreen extends ConsumerWidget {
  const JournalEntryDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalNotifierProvider);
    final entry = state.entryById(entryId);

    if (entry == null) {
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
              'This entry is no longer available.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final mood = entry.mood;
    final accent = mood?.accentColor ?? AppColors.accentPurple;

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
              context.showAppSnackBar('Editing entries is coming soon.');
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final ok = await showDeleteConfirmDialog(
                context,
                title: 'Delete journal entry?',
                message:
                    'This will permanently remove this entry. This cannot be undone.',
              );
              if (!context.mounted || !ok) return;
              final err = await ref
                  .read(journalNotifierProvider.notifier)
                  .deleteEntry(entryId);
              if (!context.mounted) return;
              if (err != null) {
                context.showAppSnackBar(err, isError: true);
                return;
              }
              context.showAppSnackBar('Entry deleted');
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
          AppSpacing.xxl,
        ),
        children: [
          Text(
            entry.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            DateFormat.yMMMEd().add_jm().format(entry.createdAt),
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          if (mood != null || (entry.tag != null && entry.tag!.isNotEmpty)) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                if (mood != null)
                  Chip(
                    label: Text(mood.label),
                    backgroundColor: accent.withValues(alpha: 0.16),
                    side: BorderSide(color: accent.withValues(alpha: 0.35)),
                    labelStyle: textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                if (entry.tag != null && entry.tag!.isNotEmpty)
                  Chip(
                    label: Text(entry.tag!),
                    backgroundColor:
                        AppColors.surfaceMuted.withValues(alpha: 0.6),
                    side: const BorderSide(color: AppColors.glassBorderSubtle),
                    labelStyle: textTheme.labelMedium,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppGlassCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            radius: AppRadii.xl,
            child: SelectableText(
              entry.content,
              style: textTheme.bodyLarge?.copyWith(
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
