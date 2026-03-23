import 'models/mood_level.dart';
import 'models/mood_log_entry_model.dart';

/// Seed mood logs for the last several days (replace with API later).
List<MoodLogEntryModel> buildMockMoodLogs({required DateTime now}) {
  final today = DateTime(now.year, now.month, now.day);

  MoodLogEntryModel log(
    int daysAgo,
    MoodLevel mood, {
    String? note,
    int hour = 20,
  }) {
    final day = today.subtract(Duration(days: daysAgo));
    return MoodLogEntryModel(
      id: 'm_${daysAgo}_$hour',
      mood: mood,
      note: note,
      loggedAt: day.add(Duration(hours: hour)),
    );
  }

  return [
    log(0, MoodLevel.good, note: 'Focused morning, calmer afternoon.'),
    log(1, MoodLevel.okay, note: 'Busy day, but productive.'),
    log(2, MoodLevel.great, hour: 19),
    log(3, MoodLevel.low, note: 'A little drained — early night.'),
    log(4, MoodLevel.stressed, note: 'Deadlines stacking; took a walk.'),
    log(5, MoodLevel.good),
    log(6, MoodLevel.okay, note: 'Feeling steady.'),
  ];
}
