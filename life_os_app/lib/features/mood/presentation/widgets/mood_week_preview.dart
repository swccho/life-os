import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../data/models/mood_level.dart';
import '../providers/mood_notifier.dart';

class MoodWeekPreview extends StatelessWidget {
  const MoodWeekPreview({
    super.key,
    required this.slots,
    this.headerTrailing,
  });

  final List<MoodDaySlot> slots;
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Last 7 days',
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ?headerTrailing,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < slots.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: _DayPill(slot: slots[i]),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({required this.slot});

  final MoodDaySlot slot;

  static String _dayAbbrev(DateTime day) {
    final raw = DateFormat.E().format(day);
    if (raw.length >= 2) {
      return raw.substring(0, 2).toUpperCase();
    }
    return raw.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final log = slot.log;
    final abbrev = _dayAbbrev(slot.day);
    final accent = log?.mood.accentColor ?? AppColors.textDisabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          abbrev,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
                fontSize: 10,
                letterSpacing: 0.2,
              ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.sm + 2),
              color: log == null
                  ? AppColors.surfaceMuted.withValues(alpha: 0.42)
                  : accent.withValues(alpha: 0.14),
              border: Border.all(
                color: log == null
                    ? AppColors.glassBorderSubtle
                    : accent.withValues(alpha: 0.32),
              ),
            ),
            child: Center(
              child: log == null
                  ? Icon(
                      Icons.remove_rounded,
                      size: 16,
                      color: AppColors.textMuted.withValues(alpha: 0.65),
                    )
                  : Text(
                      log.mood.shortLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: accent,
                            fontSize: 11,
                            letterSpacing: -0.2,
                          ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
