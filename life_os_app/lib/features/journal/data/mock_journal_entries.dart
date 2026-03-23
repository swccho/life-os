import 'models/journal_entry_model.dart';
import '../../mood/data/models/mood_level.dart';

/// Realistic seed data for the Journal module (replace with API later).
List<JournalEntryModel> buildMockJournalEntries({required DateTime now}) {
  final today = DateTime(now.year, now.month, now.day);
  DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  return [
    JournalEntryModel(
      id: 'j1',
      title: 'A productive start',
      content:
          'Blocked two hours for deep work this morning. The quiet helped me '
          'ship the dashboard polish. I want to protect that rhythm tomorrow.',
      mood: MoodLevel.good,
      tag: 'Work',
      entryDate: today,
      createdAt: today.add(const Duration(hours: 9, minutes: 20)),
      updatedAt: today.add(const Duration(hours: 9, minutes: 20)),
    ),
    JournalEntryModel(
      id: 'j2',
      title: 'Feeling a bit overwhelmed',
      content:
          'Too many threads at once — inbox, habits, and a looming deadline. '
          'Writing this down already feels lighter. Tomorrow: one priority first.',
      mood: MoodLevel.stressed,
      tag: 'Reflection',
      entryDate: dayOnly(now.subtract(const Duration(days: 1))),
      createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
    ),
    JournalEntryModel(
      id: 'j3',
      title: 'Small wins today',
      content:
          'Walked outside, cleared the dishes, and sent one hard message I was '
          'avoiding. Not glamorous, but honest progress.',
      mood: MoodLevel.great,
      tag: 'Gratitude',
      entryDate: dayOnly(now.subtract(const Duration(days: 2))),
      createdAt: now.subtract(const Duration(days: 2, hours: 5)),
      updatedAt: now.subtract(const Duration(days: 2, hours: 5)),
    ),
    JournalEntryModel(
      id: 'j4',
      title: 'Ideas for next week',
      content:
          'Journal + mood check-in as a nightly ritual. Batch errands Sunday. '
          'Try a softer evening wind-down without screens.',
      mood: MoodLevel.okay,
      tag: 'Planning',
      entryDate: dayOnly(now.subtract(const Duration(days: 4))),
      createdAt: now.subtract(const Duration(days: 4, hours: 1)),
      updatedAt: now.subtract(const Duration(days: 4, hours: 1)),
    ),
  ];
}
