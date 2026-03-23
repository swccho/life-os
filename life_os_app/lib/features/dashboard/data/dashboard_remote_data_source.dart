import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> fetchSummary() async {
    final (raw, _) = await _client.get(ApiEndpoints.dashboard);
    if (raw is! Map<String, dynamic>) {
      throw StateError('Invalid dashboard payload');
    }
    return raw;
  }
}
