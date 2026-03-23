import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository.dart';

final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource(ref.watch(apiClientProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    remote: ref.watch(dashboardRemoteDataSourceProvider),
    useMock: AppConfig.useMockData,
  );
});
