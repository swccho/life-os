import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/mood_remote_data_source.dart';
import '../../data/repositories/mood_repository.dart';

final moodRemoteDataSourceProvider = Provider<MoodRemoteDataSource>((ref) {
  return MoodRemoteDataSource(ref.watch(apiClientProvider));
});

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(
    remote: ref.watch(moodRemoteDataSourceProvider),
    useMock: AppConfig.useMockData,
  );
});
