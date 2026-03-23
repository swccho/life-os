import '../dto/habit_dto.dart';
import '../models/habit_model.dart';

HabitModel habitDtoToModel(
  HabitDto dto, {
  Set<String> completedDates = const {},
  Map<String, String> logIdsByDateKey = const {},
}) {
  final frequency = _mapApiFrequency(dto.frequencyType);
  var h = HabitModel(
    id: dto.id,
    title: dto.name,
    description: dto.description ?? '',
    category: HabitCategory.health,
    frequency: frequency,
    streakCount: 0,
    completedDates: completedDates,
    logIdsByDateKey: logIdsByDateKey,
    targetLabel: dto.targetCount > 1 ? '${dto.targetCount}×' : null,
    partOfDay: HabitPartOfDay.any,
    createdAt: dto.createdAt ?? DateTime.now(),
    weeklyDueWeekday:
        frequency == HabitFrequency.weekly ? DateTime.monday : null,
  );
  final now = DateTime.now();
  return h.copyWith(
    streakCount: HabitStreakCalculator.currentStreak(h, now),
  );
}

HabitFrequency _mapApiFrequency(String raw) {
  switch (raw) {
    case 'weekly':
      return HabitFrequency.weekly;
    case 'daily':
    default:
      return HabitFrequency.daily;
  }
}

String habitUiFrequencyToApi(HabitFrequency f) {
  switch (f) {
    case HabitFrequency.weekly:
      return 'weekly';
    case HabitFrequency.daily:
    case HabitFrequency.weekdays:
    case HabitFrequency.custom:
      return 'daily';
  }
}

int habitTargetCountFromLabel(String? targetLabel) {
  if (targetLabel == null || targetLabel.trim().isEmpty) return 1;
  final n = int.tryParse(targetLabel.trim());
  return n != null && n >= 1 ? n : 1;
}
