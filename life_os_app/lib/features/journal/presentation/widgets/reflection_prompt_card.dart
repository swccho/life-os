import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

const _kPrompts = [
  'What made today meaningful?',
  'What do you want to improve tomorrow?',
  'What are you grateful for today?',
  'What felt surprisingly easy today?',
  'What would you tell a calmer version of yourself?',
];

/// Featured reflection prompt — rotates deterministically by day.
class ReflectionPromptCard extends StatelessWidget {
  const ReflectionPromptCard({super.key, required this.now});

  final DateTime now;

  String get _prompt {
    final i = now.difference(DateTime(2020)).inDays.abs() % _kPrompts.length;
    return _kPrompts[i];
  }

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
            AppColors.accentPurple.withValues(alpha: 0.18),
            AppColors.accentCyan.withValues(alpha: 0.08),
            AppColors.surfaceElevated.withValues(alpha: 0.5),
          ],
        ),
        border: Border.all(
          color: AppColors.accentPurple.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowPurple,
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: AppColors.accentCyan.withValues(alpha: 0.9),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Today’s cue',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _prompt,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Take a breath. A few honest lines are enough.',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
