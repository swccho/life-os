import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response_parser.dart';
import 'dto/journal_entry_dto.dart';

class JournalRemoteDataSource {
  JournalRemoteDataSource(this._client);

  final ApiClient _client;

  Future<(List<JournalEntryDto> items, PageMeta? meta)> list({
    int page = 1,
  }) async {
    final (raw, meta) = await _client.get(
      ApiEndpoints.journalEntries,
      queryParameters: {'page': page},
    );
    return (_dtoList(raw), meta);
  }

  Future<JournalEntryDto> get(String id) async {
    final (raw, _) = await _client.get(ApiEndpoints.journalEntry(id));
    return JournalEntryDto.fromJson(_asObject(raw));
  }

  Future<JournalEntryDto> create(Map<String, dynamic> body) async {
    final (raw, _) = await _client.post(
      ApiEndpoints.journalEntries,
      data: body,
    );
    return JournalEntryDto.fromJson(_asObject(raw));
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.journalEntry(id));
  }

  List<JournalEntryDto> _dtoList(Object? data) {
    if (data is! List) return [];
    return data
        .map((e) => JournalEntryDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Map<String, dynamic> _asObject(Object? data) {
    if (data is! Map) {
      throw StateError('Expected journal entry object');
    }
    return Map<String, dynamic>.from(data);
  }
}
