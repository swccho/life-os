import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/mood_level.dart';
import '../../data/models/mood_log_entry_model.dart';

class MoodHistoryItem extends StatelessWidget {
  const MoodHistoryItem({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  final MoodLogEntryModel entry;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = entry.mood.accentColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceElevated.withValues(alpha: 0.65),
              AppColors.surfaceMuted.withValues(alpha: 0.5),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      color: accent.withValues(alpha: 0.16),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Text(
                      entry.mood.label,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat.yMMMd().add_jm().format(entry.loggedAt),
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: () => onDelete(),
                  ),
                ],
              ),
              if (entry.note != null && entry.note!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  entry.note!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
