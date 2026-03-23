import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';

class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({
    super.key,
    required this.onAddTask,
    required this.onLogHabit,
    required this.onWriteJournal,
    required this.onUpdateMood,
  });

  final VoidCallback onAddTask;
  final VoidCallback onLogHabit;
  final VoidCallback onWriteJournal;
  final VoidCallback onUpdateMood;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.35,
          children: [
            _QuickActionTile(
              icon: Icons.add_task_rounded,
              label: 'Add Task',
              accent: AppColors.neonPrimary,
              onTap: onAddTask,
            ),
            _QuickActionTile(
              icon: Icons.autorenew_rounded,
              label: 'Log Habit',
              accent: AppColors.accentCyan,
              onTap: onLogHabit,
            ),
            _QuickActionTile(
              icon: Icons.edit_note_rounded,
              label: 'Write Journal',
              accent: AppColors.accentPurple,
              onTap: onWriteJournal,
            ),
            _QuickActionTile(
              icon: Icons.mood_rounded,
              label: 'Update Mood',
              accent: AppColors.accentPink,
              onTap: onUpdateMood,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatefulWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(AppRadii.lg),
          splashColor: widget.accent.withValues(alpha: 0.12),
          highlightColor: widget.accent.withValues(alpha: 0.06),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassFillTop.withValues(alpha: 0.35),
                  AppColors.surfaceMuted.withValues(alpha: 0.55),
                ],
              ),
              border: Border.all(
                color: widget.accent.withValues(alpha: 0.28),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accent.withValues(alpha: 0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.accent, size: 28),
                  const Spacer(),
                  Text(
                    widget.label,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
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
