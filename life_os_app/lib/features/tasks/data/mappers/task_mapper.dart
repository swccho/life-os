import '../dto/task_dto.dart';
import '../models/task_model.dart';

TaskModel taskDtoToModel(TaskDto dto) {
  final isCompleted =
      dto.status == 'completed' || dto.completedAt != null;
  final priority = _mapPriority(dto.priority);
  return TaskModel(
    id: dto.id,
    title: dto.title,
    description: dto.description ?? '',
    isCompleted: isCompleted,
    priority: priority,
    dueDate: dto.dueDate,
    category: TaskCategory.personal,
    createdAt: dto.createdAt,
  );
}

TaskPriority _mapPriority(String? raw) {
  switch (raw) {
    case 'high':
      return TaskPriority.high;
    case 'low':
      return TaskPriority.low;
    case 'medium':
    default:
      return TaskPriority.medium;
  }
}

String taskPriorityToApi(TaskPriority p) {
  switch (p) {
    case TaskPriority.high:
      return 'high';
    case TaskPriority.medium:
      return 'medium';
    case TaskPriority.low:
      return 'low';
  }
}

String? taskDueDateToApi(DateTime? due) {
  if (due == null) return null;
  return due.toIso8601String();
}
