import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../data/models/mood_level.dart';
import '../providers/mood_notifier.dart';
import 'mood_selector.dart';
import 'mood_week_preview.dart';

/// Today’s mood check-in — glass card, grouped mood control, compact note, week strip.
class MoodCheckInCard extends ConsumerStatefulWidget {
  const MoodCheckInCard({
    super.key,
    required this.onOpenHistory,
  });

  final VoidCallback onOpenHistory;

  @override
  ConsumerState<MoodCheckInCard> createState() => _MoodCheckInCardState();
}

class _MoodCheckInCardState extends ConsumerState<MoodCheckInCard> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _applyMood(MoodLevel level) async {
    final err = await ref
        .read(moodNotifierProvider.notifier)
        .logToday(level, _noteController.text);
    if (!mounted) return;
    if (err != null) {
      context.showAppSnackBar(err, isError: true);
    } else {
      context.showAppSnackBar('Mood saved for today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final moodState = ref.watch(moodNotifierProvider);
    final today = moodState.todayLog(now);
    final week = moodState.weekPreview(now);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return AppGlassCard(
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'One tap to log. Add a short note if you like.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(
                color: AppColors.glassBorderSubtle.withValues(alpha: 0.9),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: MoodSelector(
                selected: today?.mood,
                onSelected: _applyMood,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _noteController,
            maxLines: 2,
            maxLength: 160,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) =>
                const SizedBox.shrink(),
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Optional note',
              helperText: '${_noteController.text.length}/160',
              helperStyle: textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
              hintStyle: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.28),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
                borderSide: BorderSide(
                  color: AppColors.glassBorderSubtle.withValues(alpha: 0.85),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
                borderSide: BorderSide(
                  color: AppColors.glassBorderSubtle.withValues(alpha: 0.85),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
                borderSide: BorderSide(
                  color: scheme.primary.withValues(alpha: 0.65),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 2,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          MoodWeekPreview(
            slots: week,
            headerTrailing: TextButton.icon(
              onPressed: widget.onOpenHistory,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.accentCyan,
              ),
              icon: const Icon(Icons.history_rounded, size: 18),
              label: Text(
                'History',
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
