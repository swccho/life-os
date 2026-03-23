import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response_parser.dart';
import 'dto/habit_dto.dart';
import 'dto/habit_log_dto.dart';

class HabitRemoteDataSource {
  HabitRemoteDataSource(this._client);

  final ApiClient _client;

  Future<(List<HabitDto> items, PageMeta? meta)> listHabits({int page = 1}) async {
    final (raw, meta) = await _client.get(
      ApiEndpoints.habits,
      queryParameters: {'page': page},
    );
    final list = _habitList(raw);
    return (list, meta);
  }

  Future<(List<HabitLogDto> items, PageMeta? meta)> listLogs(
    String habitId, {
    int page = 1,
  }) async {
    final (raw, meta) = await _client.get(
      ApiEndpoints.habitLogs(habitId),
      queryParameters: {'page': page},
    );
    final list = _logList(raw);
    return (list, meta);
  }

  Future<HabitLogDto> createLog(
    String habitId,
    Map<String, dynamic> body,
  ) async {
    final (raw, _) = await _client.post(
      ApiEndpoints.habitLogs(habitId),
      data: body,
    );
    return HabitLogDto.fromJson(_asObject(raw));
  }

  Future<void> deleteLog(String logId) async {
    await _client.delete(ApiEndpoints.habitLog(logId));
  }

  Future<void> deleteHabit(String habitId) async {
    await _client.delete(ApiEndpoints.habit(habitId));
  }

  Future<HabitDto> createHabit(Map<String, dynamic> body) async {
    final (raw, _) = await _client.post(ApiEndpoints.habits, data: body);
    return HabitDto.fromJson(_asObject(raw));
  }

  List<HabitDto> _habitList(Object? data) {
    if (data is! List) return [];
    return data
        .map((e) => HabitDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  List<HabitLogDto> _logList(Object? data) {
    if (data is! List) return [];
    return data
        .map((e) => HabitLogDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Map<String, dynamic> _asObject(Object? data) {
    if (data is! Map) {
      throw StateError('Expected object in API response');
    }
    return Map<String, dynamic>.from(data);
  }
}
