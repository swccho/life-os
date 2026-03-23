import '../../../../core/network/api_response_parser.dart';
import '../mappers/task_mapper.dart';
import '../mock_tasks.dart';
import '../models/task_model.dart';
import '../task_remote_data_source.dart';

class TaskRepository {
  TaskRepository({
    required TaskRemoteDataSource remote,
    required bool useMock,
  })  : _remote = remote,
        _useMock = useMock;

  final TaskRemoteDataSource _remote;
  final bool _useMock;

  Future<(List<TaskModel> tasks, PageMeta? meta)> fetchTasks({int page = 1}) async {
    if (_useMock) {
      return (buildMockTasks(now: DateTime.now()), null);
    }
    final (dtos, meta) = await _remote.list(page: page);
    return (dtos.map(taskDtoToModel).toList(), meta);
  }

  Future<TaskModel> fetchTask(String id) async {
    if (_useMock) {
      final list = buildMockTasks(now: DateTime.now());
      for (final t in list) {
        if (t.id == id) return t;
      }
      throw StateError('Task not found');
    }
    final dto = await _remote.get(id);
    return taskDtoToModel(dto);
  }

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
    required TaskCategory category,
    DateTime? dueDate,
  }) async {
    if (_useMock) {
      return TaskModel(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        description: description,
        isCompleted: false,
        priority: priority,
        dueDate: dueDate,
        category: category,
        createdAt: DateTime.now(),
      );
    }
    final body = <String, dynamic>{
      'title': title,
      if (description.isNotEmpty) 'description': description,
      'priority': taskPriorityToApi(priority),
      if (dueDate != null) 'due_date': taskDueDateToApi(dueDate),
      'status': 'pending',
    };
    final created = await _remote.create(body);
    return taskDtoToModel(created).copyWith(category: category);
  }

  Future<void> deleteTask(String id) async {
    if (_useMock) return;
    await _remote.delete(id);
  }

  Future<TaskModel> updateCompletion(String id, bool completed) async {
    if (_useMock) {
      throw UnsupportedError('Mock tasks toggle is handled locally.');
    }
    final body = completed
        ? <String, dynamic>{
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          }
        : <String, dynamic>{
            'status': 'pending',
            'completed_at': null,
          };
    final dto = await _remote.update(id, body);
    return taskDtoToModel(dto);
  }
}
