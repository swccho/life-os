/// REST paths relative to API base URL (includes `/api` prefix in [BaseOptions.baseUrl]).
abstract final class ApiEndpoints {
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static String task(String id) => '/tasks/$id';
  static const String habits = '/habits';
  static String habit(String id) => '/habits/$id';
  static String habitLogs(String habitId) => '/habits/$habitId/logs';
  static String habitLog(String logId) => '/habit-logs/$logId';
  static const String journalEntries = '/journal-entries';
  static String journalEntry(String id) => '/journal-entries/$id';
  static const String moodEntries = '/mood-entries';
  static String moodEntry(String id) => '/mood-entries/$id';
}
