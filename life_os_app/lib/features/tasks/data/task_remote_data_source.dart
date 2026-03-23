import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response_parser.dart';
import 'dto/task_dto.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource(this._client);

  final ApiClient _client;

  Future<(List<TaskDto> items, PageMeta? meta)> list({int page = 1}) async {
    final (raw, meta) = await _client.get(
      ApiEndpoints.tasks,
      queryParameters: {'page': page},
    );
    final list = _asDtoList(raw);
    return (list, meta);
  }

  Future<TaskDto> get(String id) async {
    final (raw, _) = await _client.get(ApiEndpoints.task(id));
    return TaskDto.fromJson(_asObject(raw));
  }

  Future<TaskDto> create(Map<String, dynamic> body) async {
    final (raw, _) = await _client.post(
      ApiEndpoints.tasks,
      data: body,
    );
    return TaskDto.fromJson(_asObject(raw));
  }

  Future<TaskDto> update(String id, Map<String, dynamic> body) async {
    final (raw, _) = await _client.patch(
      ApiEndpoints.task(id),
      data: body,
    );
    return TaskDto.fromJson(_asObject(raw));
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.task(id));
  }

  List<TaskDto> _asDtoList(Object? data) {
    if (data is! List) return [];
    return data
        .map((e) => TaskDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Map<String, dynamic> _asObject(Object? data) {
    if (data is! Map) {
      throw StateError('Expected task object in API response');
    }
    return Map<String, dynamic>.from(data);
  }
}
