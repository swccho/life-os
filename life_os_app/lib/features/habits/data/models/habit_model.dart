import 'package:equatable/equatable.dart';

enum HabitCategory { health, mindset, learning, productivity, fitness }

enum HabitFrequency { daily, weekdays, weekly, custom }

/// When during the day the habit fits best (for labels and optional filters).
enum HabitPartOfDay { morning, afternoon, evening, any }

class HabitModel extends Equatable {
  const HabitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.streakCount,
    required this.completedDates,
    this.logIdsByDateKey = const {},
    this.targetLabel,
    required this.partOfDay,
    required this.createdAt,
    this.weeklyDueWeekday,
  });

  final String id;
  final String title;
  final String description;
  final HabitCategory category;
  final HabitFrequency frequency;
  /// Cached current streak; recomputed when completions change.
  final int streakCount;
  /// ISO local date keys `yyyy-MM-dd`.
  final Set<String> completedDates;
  /// API habit log id per `yyyy-MM-dd` (for undo / DELETE).
  final Map<String, String> logIdsByDateKey;
  final String? targetLabel;
  final HabitPartOfDay partOfDay;
  final DateTime createdAt;
  /// For [HabitFrequency.weekly]: `DateTime.weekday` (1 = Mon … 7 = Sun).
  final int? weeklyDueWeekday;

  bool isCompletedOn(DateTime day) {
    return completedDates.contains(HabitDateUtils.toKey(day));
  }

  bool completedToday(DateTime now) => isCompletedOn(now);

  bool appliesToDate(DateTime day) {
    switch (frequency) {
      case HabitFrequency.daily:
      case HabitFrequency.custom:
        return true;
      case HabitFrequency.weekdays:
        final w = day.weekday;
        return w >= DateTime.monday && w <= DateTime.friday;
      case HabitFrequency.weekly:
        final due = weeklyDueWeekday ?? DateTime.monday;
        return day.weekday == due;
    }
  }

  HabitModel copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    int? streakCount,
    Set<String>? completedDates,
    Map<String, String>? logIdsByDateKey,
    String? targetLabel,
    bool clearTargetLabel = false,
    HabitPartOfDay? partOfDay,
    DateTime? createdAt,
    int? weeklyDueWeekday,
    bool clearWeeklyDueWeekday = false,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      streakCount: streakCount ?? this.streakCount,
      completedDates: completedDates ?? this.completedDates,
      logIdsByDateKey: logIdsByDateKey ?? this.logIdsByDateKey,
      targetLabel:
          clearTargetLabel ? null : (targetLabel ?? this.targetLabel),
      partOfDay: partOfDay ?? this.partOfDay,
      createdAt: createdAt ?? this.createdAt,
      weeklyDueWeekday: clearWeeklyDueWeekday
          ? null
          : (weeklyDueWeekday ?? this.weeklyDueWeekday),
    );
  }

  @override
  List<Object?> get props {
    final keys = completedDates.toList()..sort();
    final logKeys = logIdsByDateKey.keys.toList()..sort();
    return [
      id,
      title,
      description,
      category,
      frequency,
      streakCount,
      keys,
      logKeys,
      for (final k in logKeys) logIdsByDateKey[k],
      targetLabel,
      partOfDay,
      createdAt,
      weeklyDueWeekday,
    ];
  }
}

abstract final class HabitDateUtils {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static String toKey(DateTime d) {
    final x = dateOnly(d);
    final m = x.month.toString().padLeft(2, '0');
    final day = x.day.toString().padLeft(2, '0');
    return '${x.year}-$m-$day';
  }
}

/// Consecutive calendar days with a completion, anchored from today or yesterday.
abstract final class HabitStreakCalculator {
  static int currentStreak(HabitModel h, DateTime now) {
    var d = HabitDateUtils.dateOnly(now);
    if (!h.completedDates.contains(HabitDateUtils.toKey(d))) {
      d = d.subtract(const Duration(days: 1));
      if (!h.completedDates.contains(HabitDateUtils.toKey(d))) {
        return 0;
      }
    }
    var n = 0;
    while (h.completedDates.contains(HabitDateUtils.toKey(d))) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }

  /// Share of last 7 calendar days (including today) that have a completion.
  static double lastSevenDayRate(HabitModel h, DateTime now) {
    var hit = 0;
    for (var i = 0; i < 7; i++) {
      final d = HabitDateUtils.dateOnly(now).subtract(Duration(days: i));
      if (h.completedDates.contains(HabitDateUtils.toKey(d))) {
        hit++;
      }
    }
    return hit / 7.0;
  }
}
