import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../mood/data/models/mood_level.dart';
import '../../data/models/journal_entry_model.dart';

class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final JournalEntryModel entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mood = entry.mood;
    final accent = mood?.accentColor ?? AppColors.accentPurple;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          splashColor: accent.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassFillTop.withValues(alpha: 0.16),
                  AppColors.glassFillBottom.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: accent.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.06),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        DateFormat.MMMd().add_jm().format(entry.createdAt),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (entry.previewSnippet.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.previewSnippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (mood != null)
                        _SoftChip(
                          label: mood.label,
                          color: accent,
                        ),
                      if (entry.tag != null && entry.tag!.isNotEmpty)
                        _SoftChip(
                          label: entry.tag!,
                          color: AppColors.textMuted,
                        ),
                      _SoftChip(
                        label: '${entry.content.trim().length} chars',
                        color: AppColors.textMuted,
                        subtle: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({
    required this.label,
    required this.color,
    this.subtle = false,
  });

  final String label;
  final Color color;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        color: color.withValues(alpha: subtle ? 0.08 : 0.14),
        border: Border.all(
          color: color.withValues(alpha: subtle ? 0.12 : 0.22),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: subtle ? AppColors.textMuted : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
