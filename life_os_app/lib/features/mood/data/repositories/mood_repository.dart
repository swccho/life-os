import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../mappers/mood_mapper.dart';
import '../mock_mood_logs.dart';
import '../models/mood_level.dart';
import '../models/mood_log_entry_model.dart';
import '../mood_remote_data_source.dart';

class MoodRepository {
  MoodRepository({
    required MoodRemoteDataSource remote,
    required bool useMock,
  })  : _remote = remote,
        _useMock = useMock;

  final MoodRemoteDataSource _remote;
  final bool _useMock;

  Future<(List<MoodLogEntryModel> logs, PageMeta? meta)> fetchLogs({
    int page = 1,
  }) async {
    if (_useMock) {
      return (buildMockMoodLogs(now: DateTime.now()), null);
    }
    final (dtos, meta) = await _remote.list(page: page);
    return (dtos.map(moodDtoToModel).toList(), meta);
  }

  Future<MoodLogEntryModel> logToday({
    required MoodLevel mood,
    String? note,
    required DateTime now,
  }) async {
    if (_useMock) {
      return MoodLogEntryModel(
        id: 'm_${now.microsecondsSinceEpoch}',
        mood: mood,
        note: _trimmed(note),
        loggedAt: now,
      );
    }

    final ymd = moodEntryDateToApi(DateTime(now.year, now.month, now.day));
    final body = <String, dynamic>{
      'mood_score': moodLevelToScore(mood),
      'mood_label': mood.label,
      if (note != null && note.trim().isNotEmpty) 'notes': note.trim(),
      'entry_date': ymd,
    };

    try {
      final dto = await _remote.create(body);
      return moodDtoToModel(dto);
    } on ApiException catch (e) {
      if (e.kind == ApiFailureKind.conflict) {
        final (todayList, _) = await _remote.list(page: 1, entryDate: ymd);
        if (todayList.isEmpty) rethrow;
        final id = todayList.first.id;
        final dto = await _remote.patch(id, {
          'mood_score': moodLevelToScore(mood),
          'mood_label': mood.label,
          if (note != null && note.trim().isNotEmpty) 'notes': note.trim(),
        });
        return moodDtoToModel(dto);
      }
      rethrow;
    }
  }

  Future<void> deleteEntry(String id) async {
    if (_useMock) return;
    await _remote.delete(id);
  }

  static String? _trimmed(String? note) {
    final t = note?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
