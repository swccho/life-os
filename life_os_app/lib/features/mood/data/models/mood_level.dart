import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_colors.dart';

/// Discrete mood levels for check-ins and optional journal tags.
enum MoodLevel { great, good, okay, low, stressed }

extension MoodLevelX on MoodLevel {
  String get label {
    switch (this) {
      case MoodLevel.great:
        return 'Great';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.okay:
        return 'Okay';
      case MoodLevel.low:
        return 'Low';
      case MoodLevel.stressed:
        return 'Stressed';
    }
  }

  String get shortLabel {
    switch (this) {
      case MoodLevel.great:
        return 'Gr';
      case MoodLevel.good:
        return 'Gd';
      case MoodLevel.okay:
        return 'Ok';
      case MoodLevel.low:
        return 'Lo';
      case MoodLevel.stressed:
        return 'St';
    }
  }

  Color get accentColor {
    switch (this) {
      case MoodLevel.great:
        return AppColors.accentCyan;
      case MoodLevel.good:
        return AppColors.success;
      case MoodLevel.okay:
        return AppColors.info;
      case MoodLevel.low:
        return AppColors.warning;
      case MoodLevel.stressed:
        return AppColors.accentPink;
    }
  }
}
