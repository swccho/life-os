import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/task_remote_data_source.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(ref.watch(apiClientProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(
    remote: ref.watch(taskRemoteDataSourceProvider),
    useMock: AppConfig.useMockData,
  );
});
