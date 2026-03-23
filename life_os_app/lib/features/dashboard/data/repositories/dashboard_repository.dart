import '../dashboard_remote_data_source.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepository {
  DashboardRepository({
    required DashboardRemoteDataSource remote,
    required bool useMock,
  })  : _remote = remote,
        _useMock = useMock;

  final DashboardRemoteDataSource _remote;
  final bool _useMock;

  Future<DashboardSummary> fetchSummary() async {
    if (_useMock) {
      return DashboardSummary.mock();
    }
    final map = await _remote.fetchSummary();
    return DashboardSummary.fromJson(map);
  }
}
