import 'models/task_model.dart';

/// Realistic seed data for the Tasks module (replace with API later).
List<TaskModel> buildMockTasks({required DateTime now}) {
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final nextWeek = today.add(const Duration(days: 5));

  return [
    TaskModel(
      id: 't1',
      title: 'Finish wireframe review',
      description: 'Consolidate feedback and share the v2 link with the team.',
      isCompleted: false,
      priority: TaskPriority.high,
      dueDate: today.add(const Duration(hours: 17)),
      category: TaskCategory.work,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    TaskModel(
      id: 't2',
      title: 'Plan weekly habits',
      description: 'Pick three keystone habits and block time on the calendar.',
      isCompleted: false,
      priority: TaskPriority.medium,
      dueDate: tomorrow,
      category: TaskCategory.personal,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: 't3',
      title: 'Journal reflection at night',
      description: 'Gratitude + one lesson learned from today.',
      isCompleted: true,
      priority: TaskPriority.low,
      dueDate: today,
      category: TaskCategory.personal,
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    TaskModel(
      id: 't4',
      title: 'Client follow-up',
      description: 'Send recap email and proposed next steps.',
      isCompleted: false,
      priority: TaskPriority.high,
      dueDate: nextWeek,
      category: TaskCategory.work,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    TaskModel(
      id: 't5',
      title: 'Drink water reminder setup',
      description: 'Configure gentle reminders mid-morning and afternoon.',
      isCompleted: false,
      priority: TaskPriority.low,
      dueDate: null,
      category: TaskCategory.health,
      createdAt: now.subtract(const Duration(hours: 8)),
    ),
    TaskModel(
      id: 't6',
      title: 'Read two chapters — deep work',
      description: 'Focus block without notifications.',
      isCompleted: false,
      priority: TaskPriority.medium,
      dueDate: today.add(const Duration(hours: 20)),
      category: TaskCategory.study,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: 't7',
      title: 'Stretch & mobility 15 min',
      description: 'Neck and hips — keep it light.',
      isCompleted: true,
      priority: TaskPriority.medium,
      dueDate: yesterdaySameTime(now),
      category: TaskCategory.health,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    TaskModel(
      id: 't8',
      title: 'Inbox zero (personal)',
      description: 'Archive newsletters; reply to two threads.',
      isCompleted: false,
      priority: TaskPriority.low,
      dueDate: tomorrow,
      category: TaskCategory.personal,
      createdAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}

DateTime yesterdaySameTime(DateTime now) {
  final y = now.subtract(const Duration(days: 1));
  return DateTime(y.year, y.month, y.day, 9, 0);
}
