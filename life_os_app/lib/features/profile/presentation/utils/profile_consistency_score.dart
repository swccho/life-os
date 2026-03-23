import '../../../dashboard/data/models/dashboard_summary_model.dart';

/// Heuristic 0–100 score from dashboard signals (not clinical or predictive).
int profileConsistencyScore(DashboardSummary s) {
  final total = s.totalTasks;
  final completedRatio = total > 0 ? s.completedTasks / total : 0.0;
  final habitSignal = s.activeHabitsCount > 0
      ? (s.todayHabitLogsCount / s.activeHabitsCount).clamp(0.0, 1.0)
      : 0.0;
  final moodSignal = s.averageMoodLast7Days != null
      ? (s.averageMoodLast7Days! / 5.0).clamp(0.0, 1.0)
      : 0.5;
  final blended =
      completedRatio * 0.4 + habitSignal * 0.35 + moodSignal * 0.25;
  return (blended * 100).round().clamp(0, 100);
}

String initialsFromName(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final s = parts.first;
    if (s.length >= 2) {
      return s.substring(0, 2).toUpperCase();
    }
    return s.toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
