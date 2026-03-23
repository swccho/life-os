import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response_parser.dart';
import 'dto/mood_entry_dto.dart';

class MoodRemoteDataSource {
  MoodRemoteDataSource(this._client);

  final ApiClient _client;

  Future<(List<MoodEntryDto> items, PageMeta? meta)> list({
    int page = 1,
    String? entryDate,
  }) async {
    final q = <String, dynamic>{'page': page};
    if (entryDate != null) q['entry_date'] = entryDate;
    final (raw, meta) = await _client.get(
      ApiEndpoints.moodEntries,
      queryParameters: q,
    );
    return (_list(raw), meta);
  }

  Future<MoodEntryDto> create(Map<String, dynamic> body) async {
    final (raw, _) = await _client.post(
      ApiEndpoints.moodEntries,
      data: body,
    );
    return MoodEntryDto.fromJson(_asObject(raw));
  }

  Future<MoodEntryDto> patch(String id, Map<String, dynamic> body) async {
    final (raw, _) = await _client.patch(
      ApiEndpoints.moodEntry(id),
      data: body,
    );
    return MoodEntryDto.fromJson(_asObject(raw));
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.moodEntry(id));
  }

  List<MoodEntryDto> _list(Object? data) {
    if (data is! List) return [];
    return data
        .map((e) => MoodEntryDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Map<String, dynamic> _asObject(Object? data) {
    if (data is! Map) {
      throw StateError('Expected mood entry object');
    }
    return Map<String, dynamic>.from(data);
  }
}
