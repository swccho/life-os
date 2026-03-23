import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../data/models/habit_model.dart';
import 'habit_repository_provider.dart';

enum HabitViewFilter { all, today, completed, missed }

enum HabitsLoadStatus { initial, loading, refreshing, ready, error }

class HabitSummaryStats {
  const HabitSummaryStats({
    required this.completedToday,
    required this.totalHabits,
    required this.eligibleToday,
    required this.bestStreak,
    required this.consistencyScore,
  });

  final int completedToday;
  final int totalHabits;
  final int eligibleToday;
  final int bestStreak;
  final int consistencyScore;

  double get todayProgress =>
      eligibleToday == 0 ? 0 : completedToday / eligibleToday;
}

class HabitsState {
  const HabitsState({
    this.loadStatus = HabitsLoadStatus.initial,
    required this.habits,
    this.filter = HabitViewFilter.all,
    this.errorMessage,
    this.meta,
  });

  final HabitsLoadStatus loadStatus;
  final List<HabitModel> habits;
  final HabitViewFilter filter;
  final String? errorMessage;
  final PageMeta? meta;

  bool get isLoading =>
      loadStatus == HabitsLoadStatus.loading ||
      loadStatus == HabitsLoadStatus.initial;

  bool get isRefreshing => loadStatus == HabitsLoadStatus.refreshing;

  HabitModel? habitById(String id) {
    try {
      return habits.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  int _consistencyScore(DateTime now) {
    if (habits.isEmpty) return 0;
    var sum = 0.0;
    for (final h in habits) {
      sum += HabitStreakCalculator.lastSevenDayRate(h, now);
    }
    return (sum / habits.length * 100).round().clamp(0, 100);
  }

  HabitSummaryStats statsFor(DateTime now) {
    final eligible =
        habits.where((h) => h.appliesToDate(HabitDateUtils.dateOnly(now)));
    final eligibleList = eligible.toList();
    final completed = eligibleList.where((h) => h.completedToday(now)).length;

    var best = 0;
    for (final h in habits) {
      if (h.streakCount > best) best = h.streakCount;
    }

    return HabitSummaryStats(
      completedToday: completed,
      totalHabits: habits.length,
      eligibleToday: eligibleList.length,
      bestStreak: best,
      consistencyScore: _consistencyScore(now),
    );
  }

  List<HabitModel> filtered(DateTime now) {
    final today = HabitDateUtils.dateOnly(now);
    Iterable<HabitModel> it = habits;
    switch (filter) {
      case HabitViewFilter.all:
        break;
      case HabitViewFilter.today:
        it = habits.where((h) => h.appliesToDate(today));
        break;
      case HabitViewFilter.completed:
        it = habits.where(
          (h) => h.appliesToDate(today) && h.completedToday(now),
        );
        break;
      case HabitViewFilter.missed:
        it = habits.where(
          (h) => h.appliesToDate(today) && !h.completedToday(now),
        );
        break;
    }
    final list = it.toList()..sort((a, b) => _sortHabits(a, b, now));
    return list;
  }

  List<HabitModel> needsAttention(DateTime now) {
    final today = HabitDateUtils.dateOnly(now);
    final missed = habits
        .where((h) => h.appliesToDate(today) && !h.completedToday(now))
        .toList()
      ..sort((a, b) => b.streakCount.compareTo(a.streakCount));
    return missed.take(2).toList();
  }

  HabitsState copyWith({
    HabitsLoadStatus? loadStatus,
    List<HabitModel>? habits,
    HabitViewFilter? filter,
    String? errorMessage,
    PageMeta? meta,
    bool clearError = false,
  }) {
    return HabitsState(
      loadStatus: loadStatus ?? this.loadStatus,
      habits: habits ?? this.habits,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      meta: meta ?? this.meta,
    );
  }
}

int _sortHabits(HabitModel a, HabitModel b, DateTime now) {
  final ac = a.completedToday(now);
  final bc = b.completedToday(now);
  if (ac != bc) return ac ? 1 : -1;
  final sr = b.streakCount.compareTo(a.streakCount);
  if (sr != 0) return sr;
  return a.title.compareTo(b.title);
}

HabitModel _withStreak(HabitModel h, DateTime now) {
  return h.copyWith(
    streakCount: HabitStreakCalculator.currentStreak(h, now),
  );
}

class HabitsNotifier extends Notifier<HabitsState> {
  @override
  HabitsState build() {
    Future.microtask(load);
    return const HabitsState(
      loadStatus: HabitsLoadStatus.loading,
      habits: [],
    );
  }

  Future<void> load() async {
    state = state.copyWith(
      loadStatus: HabitsLoadStatus.loading,
      clearError: true,
    );
    try {
      final (habits, meta) =
          await ref.read(habitRepositoryProvider).fetchHabits();
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.ready,
        habits: habits,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.habits.isEmpty) {
      await load();
      return;
    }
    state = state.copyWith(
      loadStatus: HabitsLoadStatus.refreshing,
      clearError: true,
    );
    try {
      final (habits, meta) =
          await ref.read(habitRepositoryProvider).fetchHabits();
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.ready,
        habits: habits,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.ready,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: HabitsLoadStatus.ready,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void setFilter(HabitViewFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> toggleCompleteToday(String id) async {
    final habit = state.habitById(id);
    if (habit == null) return;
    final now = DateTime.now();
    final previous = List<HabitModel>.from(state.habits);

    if (!AppConfig.useMockData) {
      final key = HabitDateUtils.toKey(now);
      final optimistic = habit.completedToday(now)
          ? _withStreak(
              habit.copyWith(
                completedDates: Set<String>.from(habit.completedDates)
                  ..remove(key),
                logIdsByDateKey: Map<String, String>.from(habit.logIdsByDateKey)
                  ..remove(key),
              ),
              now,
            )
          : _withStreak(
              habit.copyWith(
                completedDates: {...habit.completedDates, key},
              ),
              now,
            );
      state = state.copyWith(
        habits: [
          for (final h in state.habits) if (h.id == id) optimistic else h,
        ],
      );
    }

    try {
      final updated =
          await ref.read(habitRepositoryProvider).toggleToday(habit, now);
      state = state.copyWith(
        habits: [
          for (final h in state.habits) if (h.id == id) updated else h,
        ],
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        habits: AppConfig.useMockData ? state.habits : previous,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        habits: AppConfig.useMockData ? state.habits : previous,
        errorMessage: 'Could not update habit.',
      );
    }
  }

  Future<String?> createHabit({
    required String title,
    required String description,
    required HabitCategory category,
    required HabitFrequency frequency,
    required HabitPartOfDay partOfDay,
    String? targetLabel,
    int? weeklyDueWeekday,
  }) async {
    try {
      final created = await ref.read(habitRepositoryProvider).createHabit(
            title: title,
            description: description,
            category: category,
            frequency: frequency,
            partOfDay: partOfDay,
            targetLabel: targetLabel,
            weeklyDueWeekday: weeklyDueWeekday,
          );
      state = state.copyWith(
        habits: [created, ...state.habits],
        loadStatus: HabitsLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> deleteHabit(String id) async {
    if (state.habitById(id) == null) return 'Habit not found';
    try {
      await ref.read(habitRepositoryProvider).deleteHabit(id);
      state = state.copyWith(
        habits: [for (final h in state.habits) if (h.id != id) h],
        loadStatus: HabitsLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return e.message;
    } catch (_) {
      const msg = 'Could not delete habit.';
      state = state.copyWith(errorMessage: msg);
      return msg;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final habitsNotifierProvider =
    NotifierProvider<HabitsNotifier, HabitsState>(HabitsNotifier.new);
