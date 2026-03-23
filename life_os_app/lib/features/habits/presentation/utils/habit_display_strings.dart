import '../../data/models/habit_model.dart';
import '../providers/habits_notifier.dart';

abstract final class HabitDisplayStrings {
  static String category(HabitCategory c) {
    switch (c) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.mindset:
        return 'Mindset';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.fitness:
        return 'Fitness';
    }
  }

  static String frequency(HabitFrequency f) {
    switch (f) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekdays:
        return 'Weekdays';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }

  static String partOfDay(HabitPartOfDay p) {
    switch (p) {
      case HabitPartOfDay.morning:
        return 'Morning';
      case HabitPartOfDay.afternoon:
        return 'Afternoon';
      case HabitPartOfDay.evening:
        return 'Evening';
      case HabitPartOfDay.any:
        return 'Any time';
    }
  }

  static String filter(HabitViewFilter f) {
    switch (f) {
      case HabitViewFilter.all:
        return 'All';
      case HabitViewFilter.today:
        return 'Today';
      case HabitViewFilter.completed:
        return 'Done';
      case HabitViewFilter.missed:
        return 'Open';
    }
  }
}
