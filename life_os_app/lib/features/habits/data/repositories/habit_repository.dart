import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../habit_remote_data_source.dart';
import '../mappers/habit_mapper.dart';
import '../mock_habits.dart';
import '../models/habit_model.dart';

class HabitRepository {
  HabitRepository({
    required HabitRemoteDataSource remote,
    required bool useMock,
  })  : _remote = remote,
        _useMock = useMock;

  final HabitRemoteDataSource _remote;
  final bool _useMock;

  Future<(List<HabitModel> habits, PageMeta? meta)> fetchHabits() async {
    if (_useMock) {
      return (buildMockHabits(now: DateTime.now()), null);
    }
    final (dtos, meta) = await _remote.listHabits();
    final models = <HabitModel>[];
    for (final d in dtos) {
      final (logs, _) = await _remote.listLogs(d.id);
      final dates = <String>{};
      final ids = <String, String>{};
      for (final l in logs) {
        if (l.loggedDate.isNotEmpty) {
          dates.add(l.loggedDate);
          ids[l.loggedDate] = l.id;
        }
      }
      models.add(
        habitDtoToModel(
          d,
          completedDates: dates,
          logIdsByDateKey: ids,
        ),
      );
    }
    return (models, meta);
  }

  Future<HabitModel> createHabit({
    required String title,
    required String description,
    required HabitCategory category,
    required HabitFrequency frequency,
    required HabitPartOfDay partOfDay,
    String? targetLabel,
    int? weeklyDueWeekday,
  }) async {
    if (_useMock) {
      final now = DateTime.now();
      return HabitModel(
        id: 'habit_${now.microsecondsSinceEpoch}',
        title: title,
        description: description,
        category: category,
        frequency: frequency,
        streakCount: 0,
        completedDates: {},
        targetLabel: (targetLabel == null || targetLabel.trim().isEmpty)
            ? null
            : targetLabel.trim(),
        partOfDay: partOfDay,
        createdAt: now,
        weeklyDueWeekday: weeklyDueWeekday,
      );
    }
    final body = <String, dynamic>{
      'name': title,
      if (description.isNotEmpty) 'description': description,
      'frequency_type': habitUiFrequencyToApi(frequency),
      'target_count': habitTargetCountFromLabel(targetLabel),
      'is_active': true,
    };
    final dto = await _remote.createHabit(body);
    return habitDtoToModel(dto).copyWith(
      category: category,
      partOfDay: partOfDay,
      targetLabel: (targetLabel == null || targetLabel.trim().isEmpty)
          ? null
          : targetLabel.trim(),
      weeklyDueWeekday: weeklyDueWeekday,
    );
  }

  /// Toggle completion for [now]'s calendar day (API or local mock).
  Future<HabitModel> toggleToday(HabitModel current, DateTime now) async {
    if (_useMock) {
      return _toggleLocal(current, now);
    }
    final key = HabitDateUtils.toKey(now);
    if (current.completedToday(now)) {
      final logId = current.logIdsByDateKey[key];
      if (logId != null) {
        await _remote.deleteLog(logId);
      }
      final nextDates = Set<String>.from(current.completedDates)..remove(key);
      final nextLogs = Map<String, String>.from(current.logIdsByDateKey)
        ..remove(key);
      var h = current.copyWith(
        completedDates: nextDates,
        logIdsByDateKey: nextLogs,
      );
      return h.copyWith(
        streakCount: HabitStreakCalculator.currentStreak(h, now),
      );
    }
    try {
      final log = await _remote.createLog(current.id, {'logged_date': key});
      final nextDates = Set<String>.from(current.completedDates)..add(key);
      final nextLogs = Map<String, String>.from(current.logIdsByDateKey)
        ..[key] = log.id;
      var h = current.copyWith(
        completedDates: nextDates,
        logIdsByDateKey: nextLogs,
      );
      return h.copyWith(
        streakCount: HabitStreakCalculator.currentStreak(h, now),
      );
    } on ApiException catch (e) {
      if (e.kind == ApiFailureKind.conflict) {
        return refreshHabitFromApi(current, now);
      }
      rethrow;
    }
  }

  Future<HabitModel> refreshHabitFromApi(HabitModel current, DateTime now) async {
    final (logs, _) = await _remote.listLogs(current.id);
    final dates = <String>{};
    final ids = <String, String>{};
    for (final l in logs) {
      if (l.loggedDate.isNotEmpty) {
        dates.add(l.loggedDate);
        ids[l.loggedDate] = l.id;
      }
    }
    var h = current.copyWith(completedDates: dates, logIdsByDateKey: ids);
    return h.copyWith(
      streakCount: HabitStreakCalculator.currentStreak(h, now),
    );
  }

  Future<void> deleteHabit(String id) async {
    if (_useMock) return;
    await _remote.deleteHabit(id);
  }

  HabitModel _toggleLocal(HabitModel h, DateTime now) {
    final key = HabitDateUtils.toKey(now);
    final next = Set<String>.from(h.completedDates);
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    var x = h.copyWith(completedDates: next);
    return x.copyWith(
      streakCount: HabitStreakCalculator.currentStreak(x, now),
    );
  }
}
