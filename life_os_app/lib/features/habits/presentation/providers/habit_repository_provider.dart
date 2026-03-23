import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/habit_remote_data_source.dart';
import '../../data/repositories/habit_repository.dart';

final habitRemoteDataSourceProvider = Provider<HabitRemoteDataSource>((ref) {
  return HabitRemoteDataSource(ref.watch(apiClientProvider));
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(
    remote: ref.watch(habitRemoteDataSourceProvider),
    useMock: AppConfig.useMockData,
  );
});
