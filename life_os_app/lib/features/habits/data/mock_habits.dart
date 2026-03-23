import 'models/habit_model.dart';

/// Realistic seed data (replace with API later).
List<HabitModel> buildMockHabits({required DateTime now}) {
  final today = HabitDateUtils.dateOnly(now);
  final yesterday = today.subtract(const Duration(days: 1));
  final y2 = today.subtract(const Duration(days: 2));
  final y3 = today.subtract(const Duration(days: 3));

  String k(DateTime d) => HabitDateUtils.toKey(d);

  return [
    HabitModel(
      id: 'h1',
      title: 'Drink 2L water',
      description: 'Sip steadily — keep a bottle visible at your desk.',
      category: HabitCategory.health,
      frequency: HabitFrequency.daily,
      streakCount: 0,
      completedDates: {
        k(yesterday),
        k(y2),
        k(y3),
      },
      targetLabel: '2 liters',
      partOfDay: HabitPartOfDay.morning,
      createdAt: now.subtract(const Duration(days: 30)),
    ),
    HabitModel(
      id: 'h2',
      title: 'Morning stretch',
      description: 'Five minutes — neck, shoulders, and hips.',
      category: HabitCategory.fitness,
      frequency: HabitFrequency.daily,
      streakCount: 0,
      completedDates: {
        k(today),
        k(yesterday),
        k(y2),
      },
      targetLabel: '5 min',
      partOfDay: HabitPartOfDay.morning,
      createdAt: now.subtract(const Duration(days: 14)),
    ),
    HabitModel(
      id: 'h3',
      title: 'Read 10 pages',
      description: 'Fiction or non-fiction — no screens.',
      category: HabitCategory.learning,
      frequency: HabitFrequency.daily,
      streakCount: 0,
      completedDates: {k(yesterday)},
      targetLabel: '10 pages',
      partOfDay: HabitPartOfDay.evening,
      createdAt: now.subtract(const Duration(days: 21)),
    ),
    HabitModel(
      id: 'h4',
      title: 'Journal at night',
      description: 'Three lines: highlight, challenge, gratitude.',
      category: HabitCategory.mindset,
      frequency: HabitFrequency.daily,
      streakCount: 0,
      completedDates: {
        k(today),
        k(yesterday),
        k(y2),
        k(y3),
      },
      partOfDay: HabitPartOfDay.evening,
      createdAt: now.subtract(const Duration(days: 45)),
    ),
    HabitModel(
      id: 'h5',
      title: 'Walk 6,000 steps',
      description: 'Lunch walk counts — aim for movement before sunset.',
      category: HabitCategory.health,
      frequency: HabitFrequency.weekdays,
      streakCount: 0,
      completedDates: {
        k(yesterday),
        k(y2),
      },
      targetLabel: '6k steps',
      partOfDay: HabitPartOfDay.afternoon,
      createdAt: now.subtract(const Duration(days: 10)),
    ),
    HabitModel(
      id: 'h6',
      title: 'Practice coding for 30 min',
      description: 'Deep work timer — one focused Pomodoro chain.',
      category: HabitCategory.productivity,
      frequency: HabitFrequency.weekdays,
      streakCount: 0,
      completedDates: {},
      targetLabel: '30 min',
      partOfDay: HabitPartOfDay.morning,
      createdAt: now.subtract(const Duration(days: 7)),
    ),
    HabitModel(
      id: 'h7',
      title: 'Weekly planning',
      description: 'Review goals and block the top three priorities.',
      category: HabitCategory.productivity,
      frequency: HabitFrequency.weekly,
      streakCount: 0,
      completedDates: {k(yesterday)},
      partOfDay: HabitPartOfDay.morning,
      createdAt: now.subtract(const Duration(days: 60)),
      weeklyDueWeekday: DateTime.monday,
    ),
  ].map((h) => h.copyWith(streakCount: HabitStreakCalculator.currentStreak(h, now))).toList();
}
