import '../../../mood/data/models/mood_level.dart';
import '../../../../core/network/api_response_parser.dart';
import '../journal_remote_data_source.dart';
import '../mappers/journal_mapper.dart';
import '../mock_journal_entries.dart';
import '../models/journal_entry_model.dart';

class JournalRepository {
  JournalRepository({
    required JournalRemoteDataSource remote,
    required bool useMock,
  })  : _remote = remote,
        _useMock = useMock;

  final JournalRemoteDataSource _remote;
  final bool _useMock;

  Future<(List<JournalEntryModel> entries, PageMeta? meta)> fetchEntries({
    int page = 1,
  }) async {
    if (_useMock) {
      return (buildMockJournalEntries(now: DateTime.now()), null);
    }
    final (dtos, meta) = await _remote.list(page: page);
    final list = dtos.map((d) => journalDtoToModel(d)).toList();
    return (list, meta);
  }

  Future<JournalEntryModel> createEntry({
    required String title,
    required String content,
    required DateTime entryDate,
    MoodLevel? mood,
    String? tag,
  }) async {
    if (_useMock) {
      final now = DateTime.now();
      return JournalEntryModel(
        id: 'j_${now.microsecondsSinceEpoch}',
        title: title,
        content: content,
        mood: mood,
        tag: tag,
        entryDate: DateTime(entryDate.year, entryDate.month, entryDate.day),
        createdAt: now,
        updatedAt: now,
      );
    }
    final body = <String, dynamic>{
      if (title.trim().isNotEmpty) 'title': title.trim(),
      'content': content,
      'entry_date': journalEntryDateToApi(entryDate),
    };
    final dto = await _remote.create(body);
    return journalDtoToModel(dto, mood: mood, tag: tag);
  }

  Future<void> deleteEntry(String id) async {
    if (_useMock) return;
    await _remote.delete(id);
  }
}
