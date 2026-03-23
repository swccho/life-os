import 'package:flutter/material.dart';

import '../../../app/theme/tokens/app_colors.dart';

/// Replace with API-driven models when backend is ready.
class DashboardStatItem {
  const DashboardStatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class DashboardActivityItem {
  const DashboardActivityItem({
    required this.title,
    required this.category,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String category;
  final IconData icon;
  final Color accent;
}

abstract final class DashboardPreviewData {
  static const List<DashboardStatItem> stats = [
    DashboardStatItem(label: 'Tasks today', value: '5'),
    DashboardStatItem(label: 'Habits done', value: '3/5'),
    DashboardStatItem(label: 'Journal', value: '1'),
    DashboardStatItem(label: 'Focus score', value: '82'),
  ];

  static const List<DashboardActivityItem> activities = [
    DashboardActivityItem(
      title: 'Morning workout',
      category: 'Habit',
      icon: Icons.fitness_center_rounded,
      accent: AppColors.accentCyan,
    ),
    DashboardActivityItem(
      title: 'API design task',
      category: 'Task',
      icon: Icons.code_rounded,
      accent: AppColors.neonPrimary,
    ),
    DashboardActivityItem(
      title: 'Journal reflection',
      category: 'Journal',
      icon: Icons.menu_book_rounded,
      accent: AppColors.accentPurple,
    ),
    DashboardActivityItem(
      title: 'Mood check-in pending',
      category: 'Mood',
      icon: Icons.sentiment_satisfied_alt_rounded,
      accent: AppColors.accentPink,
    ),
    DashboardActivityItem(
      title: 'Deep work block',
      category: 'Task',
      icon: Icons.timer_outlined,
      accent: AppColors.warning,
    ),
  ];

  static const List<String> subtitles = [
    'Let’s make today productive.',
    'Track your life with clarity.',
    'Small steps compound into momentum.',
  ];
}
