import '../../../journal/data/dto/journal_entry_dto.dart';
import '../../../journal/data/mappers/journal_mapper.dart';
import '../../../journal/data/models/journal_entry_model.dart';
import '../../../mood/data/dto/mood_entry_dto.dart';
import '../../../mood/data/mappers/mood_mapper.dart';
import '../../../mood/data/models/mood_log_entry_model.dart';
import '../../../tasks/data/dto/task_dto.dart';
import '../../../tasks/data/mappers/task_mapper.dart';
import '../../../tasks/data/models/task_model.dart';

/// Latest habit log row from the dashboard API (for profile activity).
class LatestHabitActivityModel {
  const LatestHabitActivityModel({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.loggedDate,
    required this.count,
  });

  final int id;
  final int habitId;
  final String habitTitle;
  final String loggedDate;
  final int count;

  factory LatestHabitActivityModel.fromJson(Map<String, dynamic> json) {
    return LatestHabitActivityModel(
      id: (json['id'] as num).toInt(),
      habitId: (json['habit_id'] as num).toInt(),
      habitTitle: json['habit_title'] as String? ?? '',
      loggedDate: json['logged_date'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 1,
    );
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.activeHabitsCount,
    required this.todayHabitLogsCount,
    required this.journalEntriesCount,
    this.latestHabitActivity,
    this.latestJournalEntry,
    this.latestMoodEntry,
    this.averageMoodLast7Days,
    required this.recentTasks,
    required this.recentJournalEntries,
    required this.recentMoodEntries,
  });

  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int activeHabitsCount;
  final int todayHabitLogsCount;
  final int journalEntriesCount;
  final LatestHabitActivityModel? latestHabitActivity;
  final JournalEntryModel? latestJournalEntry;
  final MoodLogEntryModel? latestMoodEntry;
  final double? averageMoodLast7Days;
  final List<TaskModel> recentTasks;
  final List<JournalEntryModel> recentJournalEntries;
  final List<MoodLogEntryModel> recentMoodEntries;

  int get dueTodayApprox =>
      pendingTasks + inProgressTasks > 0 ? pendingTasks : totalTasks;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    int i(String k) => (json[k] as num?)?.toInt() ?? 0;

    JournalEntryModel? journal;
    final lj = json['latest_journal_entry'];
    if (lj is Map<String, dynamic>) {
      journal = journalDtoToModel(JournalEntryDto.fromJson(lj));
    }

    MoodLogEntryModel? mood;
    final lm = json['latest_mood_entry'];
    if (lm is Map<String, dynamic>) {
      mood = moodDtoToModel(MoodEntryDto.fromJson(lm));
    }

    List<TaskModel> tasks = [];
    final rt = json['recent_tasks'];
    if (rt is List) {
      tasks = rt
          .map((e) => taskDtoToModel(
                TaskDto.fromJson(Map<String, dynamic>.from(e as Map)),
              ))
          .toList();
    }

    List<JournalEntryModel> journals = [];
    final rj = json['recent_journal_entries'];
    if (rj is List) {
      journals = rj
          .map((e) => journalDtoToModel(
                JournalEntryDto.fromJson(Map<String, dynamic>.from(e as Map)),
              ))
          .toList();
    }

    List<MoodLogEntryModel> moods = [];
    final rm = json['recent_mood_entries'];
    if (rm is List) {
      moods = rm
          .map((e) => moodDtoToModel(
                MoodEntryDto.fromJson(Map<String, dynamic>.from(e as Map)),
              ))
          .toList();
    }

    LatestHabitActivityModel? habitActivity;
    final lha = json['latest_habit_activity'];
    if (lha is Map<String, dynamic>) {
      habitActivity = LatestHabitActivityModel.fromJson(lha);
    }

    return DashboardSummary(
      totalTasks: i('total_tasks'),
      completedTasks: i('completed_tasks'),
      pendingTasks: i('pending_tasks'),
      inProgressTasks: i('in_progress_tasks'),
      activeHabitsCount: i('active_habits_count'),
      todayHabitLogsCount: i('today_habit_logs_count'),
      journalEntriesCount: i('journal_entries_count'),
      latestHabitActivity: habitActivity,
      latestJournalEntry: journal,
      latestMoodEntry: mood,
      averageMoodLast7Days:
          (json['average_mood_last_7_days'] as num?)?.toDouble(),
      recentTasks: tasks,
      recentJournalEntries: journals,
      recentMoodEntries: moods,
    );
  }

  /// Lightweight preview when API is disabled.
  factory DashboardSummary.mock() {
    return const DashboardSummary(
      totalTasks: 5,
      completedTasks: 2,
      pendingTasks: 2,
      inProgressTasks: 1,
      activeHabitsCount: 5,
      todayHabitLogsCount: 3,
      journalEntriesCount: 0,
      latestHabitActivity: null,
      latestJournalEntry: null,
      latestMoodEntry: null,
      averageMoodLast7Days: 3.5,
      recentTasks: [],
      recentJournalEntries: [],
      recentMoodEntries: [],
    );
  }
}
