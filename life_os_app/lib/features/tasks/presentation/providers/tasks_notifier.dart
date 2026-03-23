import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../../settings/presentation/providers/settings_notifier.dart';
import '../../data/models/task_model.dart';
import 'task_repository_provider.dart';

enum TaskViewFilter { all, today, upcoming, completed }

enum TasksLoadStatus { initial, loading, refreshing, ready, error }

class TaskStats {
  const TaskStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.dueToday,
  });

  final int total;
  final int completed;
  final int pending;
  final int dueToday;
}

class TasksState {
  const TasksState({
    this.loadStatus = TasksLoadStatus.initial,
    required this.tasks,
    this.filter = TaskViewFilter.all,
    this.errorMessage,
    this.meta,
  });

  final TasksLoadStatus loadStatus;
  final List<TaskModel> tasks;
  final TaskViewFilter filter;
  final String? errorMessage;
  final PageMeta? meta;

  bool get isLoading =>
      loadStatus == TasksLoadStatus.loading ||
      loadStatus == TasksLoadStatus.initial;

  bool get isRefreshing => loadStatus == TasksLoadStatus.refreshing;

  TaskModel? taskById(String id) {
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  TaskStats statsFor(DateTime now) {
    final dueTodayCount =
        tasks.where((t) => TaskDateUtils.isDueToday(t, now)).length;
    final completedCount = tasks.where((t) => t.isCompleted).length;
    return TaskStats(
      total: tasks.length,
      completed: completedCount,
      pending: tasks.length - completedCount,
      dueToday: dueTodayCount,
    );
  }

  TaskModel? todayFocusTask(DateTime now) {
    final candidates = tasks
        .where(
          (t) =>
              !t.isCompleted && TaskDateUtils.isDueToday(t, now),
        )
        .toList();
    if (candidates.isEmpty) return null;
    candidates.sort(_comparePriorityThenTitle);
    return candidates.first;
  }

  List<TaskModel> filtered(DateTime now) {
    Iterable<TaskModel> it = tasks;
    switch (filter) {
      case TaskViewFilter.all:
        break;
      case TaskViewFilter.today:
        it = tasks.where((t) => TaskDateUtils.isDueToday(t, now));
        break;
      case TaskViewFilter.upcoming:
        it = tasks.where(
          (t) =>
              !t.isCompleted && TaskDateUtils.isUpcoming(t, now),
        );
        break;
      case TaskViewFilter.completed:
        it = tasks.where((t) => t.isCompleted);
        break;
    }
    final list = it.toList()..sort((a, b) => _sortTasks(a, b, now));
    return list;
  }

  TasksState copyWith({
    TasksLoadStatus? loadStatus,
    List<TaskModel>? tasks,
    TaskViewFilter? filter,
    String? errorMessage,
    PageMeta? meta,
    bool clearError = false,
  }) {
    return TasksState(
      loadStatus: loadStatus ?? this.loadStatus,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      meta: meta ?? this.meta,
    );
  }
}

int _priorityRank(TaskPriority p) {
  switch (p) {
    case TaskPriority.high:
      return 0;
    case TaskPriority.medium:
      return 1;
    case TaskPriority.low:
      return 2;
  }
}

int _comparePriorityThenTitle(TaskModel a, TaskModel b) {
  final pr = _priorityRank(a.priority).compareTo(_priorityRank(b.priority));
  if (pr != 0) return pr;
  return a.title.compareTo(b.title);
}

int _sortTasks(TaskModel a, TaskModel b, DateTime now) {
  if (a.isCompleted != b.isCompleted) {
    return a.isCompleted ? 1 : -1;
  }
  final ad = a.dueDate;
  final bd = b.dueDate;
  if (ad == null && bd == null) {
    return _comparePriorityThenTitle(a, b);
  }
  if (ad == null) return 1;
  if (bd == null) return -1;
  final c = ad.compareTo(bd);
  if (c != 0) return c;
  return _comparePriorityThenTitle(a, b);
}

class TasksNotifier extends Notifier<TasksState> {
  @override
  TasksState build() {
    ref.listen(settingsNotifierProvider, (prev, next) {
      next.whenData((data) {
        final f = data.defaultTaskViewIndex == 1
            ? TaskViewFilter.today
            : TaskViewFilter.all;
        state = state.copyWith(filter: f);
      });
    });
    Future.microtask(load);
    return TasksState(
      loadStatus: TasksLoadStatus.loading,
      tasks: [],
      filter: _filterFromSettingsRead(),
    );
  }

  TaskViewFilter _filterFromSettingsRead() {
    final data = ref.read(settingsNotifierProvider).valueOrNull;
    if (data != null && data.defaultTaskViewIndex == 1) {
      return TaskViewFilter.today;
    }
    return TaskViewFilter.all;
  }

  Future<void> load() async {
    state = state.copyWith(
      loadStatus: TasksLoadStatus.loading,
      clearError: true,
      filter: _filterFromSettingsRead(),
    );
    try {
      final (tasks, meta) =
          await ref.read(taskRepositoryProvider).fetchTasks();
      state = state.copyWith(
        loadStatus: TasksLoadStatus.ready,
        tasks: tasks,
        meta: meta,
        filter: _filterFromSettingsRead(),
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: TasksLoadStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: TasksLoadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.tasks.isEmpty) {
      await load();
      return;
    }
    state = state.copyWith(
      loadStatus: TasksLoadStatus.refreshing,
      clearError: true,
    );
    try {
      final (tasks, meta) =
          await ref.read(taskRepositoryProvider).fetchTasks();
      state = state.copyWith(
        loadStatus: TasksLoadStatus.ready,
        tasks: tasks,
        meta: meta,
        filter: _filterFromSettingsRead(),
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: TasksLoadStatus.ready,
        errorMessage: e.message,
        filter: _filterFromSettingsRead(),
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: TasksLoadStatus.ready,
        errorMessage: 'Something went wrong. Please try again.',
        filter: _filterFromSettingsRead(),
      );
    }
  }

  void setFilter(TaskViewFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> toggleComplete(String id) async {
    final task = state.taskById(id);
    if (task == null) return;
    final next = !task.isCompleted;
    final previous = List<TaskModel>.from(state.tasks);
    state = state.copyWith(
      tasks: [
        for (final t in state.tasks)
          if (t.id == id) t.copyWith(isCompleted: next) else t,
      ],
    );
    if (AppConfig.useMockData) return;
    try {
      final updated =
          await ref.read(taskRepositoryProvider).updateCompletion(id, next);
      state = state.copyWith(
        tasks: [
          for (final t in state.tasks)
            if (t.id == id)
              updated.copyWith(category: t.category)
            else
              t,
        ],
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        tasks: previous,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        tasks: previous,
        errorMessage: 'Could not update task.',
      );
    }
  }

  Future<String?> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
    required TaskCategory category,
    DateTime? dueDate,
  }) async {
    try {
      final created = await ref.read(taskRepositoryProvider).createTask(
            title: title,
            description: description,
            priority: priority,
            category: category,
            dueDate: dueDate,
          );
      state = state.copyWith(
        tasks: [created, ...state.tasks],
        loadStatus: TasksLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> deleteTask(String id) async {
    if (state.taskById(id) == null) return 'Task not found';
    try {
      await ref.read(taskRepositoryProvider).deleteTask(id);
      state = state.copyWith(
        tasks: [for (final t in state.tasks) if (t.id != id) t],
        loadStatus: TasksLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return e.message;
    } catch (_) {
      const msg = 'Could not delete task.';
      state = state.copyWith(errorMessage: msg);
      return msg;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final tasksNotifierProvider =
    NotifierProvider<TasksNotifier, TasksState>(TasksNotifier.new);
