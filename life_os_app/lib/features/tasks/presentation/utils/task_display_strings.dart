import '../../data/models/task_model.dart';
import '../providers/tasks_notifier.dart';

abstract final class TaskDisplayStrings {
  static String category(TaskCategory c) {
    switch (c) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.study:
        return 'Study';
    }
  }

  static String priority(TaskPriority p) {
    switch (p) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  static String filter(TaskViewFilter f) {
    switch (f) {
      case TaskViewFilter.all:
        return 'All';
      case TaskViewFilter.today:
        return 'Today';
      case TaskViewFilter.upcoming:
        return 'Upcoming';
      case TaskViewFilter.completed:
        return 'Completed';
    }
  }
}
