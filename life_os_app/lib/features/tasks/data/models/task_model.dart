import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum TaskCategory { work, personal, health, study }

class TaskModel extends Equatable {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime? dueDate;
  final TaskCategory category;
  final DateTime createdAt;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
    TaskCategory? category,
    DateTime? createdAt,
    bool clearDueDate = false,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        priority,
        dueDate,
        category,
        createdAt,
      ];
}

/// Date-only helpers for filters (local timezone).
abstract final class TaskDateUtils {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isDueOnDay(TaskModel task, DateTime day) {
    final due = task.dueDate;
    if (due == null) return false;
    return isSameDay(dateOnly(due), dateOnly(day));
  }

  static bool isDueToday(TaskModel task, DateTime now) =>
      isDueOnDay(task, now);

  /// Due strictly after the calendar day of [now] (midnight next days onward).
  static bool isUpcoming(TaskModel task, DateTime now) {
    final due = task.dueDate;
    if (due == null) return false;
    final dueD = dateOnly(due);
    final todayD = dateOnly(now);
    return dueD.isAfter(todayD);
  }
}
