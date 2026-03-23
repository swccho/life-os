import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_radii.dart';
import '../../data/models/mood_level.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MoodLevel? selected;
  final ValueChanged<MoodLevel> onSelected;

  /// Logical width for five equal chips; [FittedBox] scales down so none clip.
  static const double _rowWidth = 336;
  static const double _rowHeight = 46;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: SizedBox(
        width: _rowWidth,
        height: _rowHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < MoodLevel.values.length; i++) ...[
              if (i > 0) const SizedBox(width: 5),
              Expanded(
                child: _MoodOptionTile(
                  level: MoodLevel.values[i],
                  selected: selected,
                  onSelected: onSelected,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MoodOptionTile extends StatelessWidget {
  const _MoodOptionTile({
    required this.level,
    required this.selected,
    required this.onSelected,
  });

  final MoodLevel level;
  final MoodLevel? selected;
  final ValueChanged<MoodLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    final isOn = selected == level;
    final c = level.accentColor;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(level),
        borderRadius: BorderRadius.circular(AppRadii.md),
        splashColor: c.withValues(alpha: 0.14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md),
            color: isOn ? c.withValues(alpha: 0.18) : c.withValues(alpha: 0.05),
            border: Border.all(
              color: isOn ? c.withValues(alpha: 0.5) : c.withValues(alpha: 0.2),
              width: isOn ? 1.5 : 1,
            ),
            boxShadow: isOn
                ? [
                    BoxShadow(
                      color: c.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            level.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: isOn ? FontWeight.w700 : FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
