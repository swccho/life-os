import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/app_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/journal_remote_data_source.dart';
import '../../data/repositories/journal_repository.dart';

final journalRemoteDataSourceProvider = Provider<JournalRemoteDataSource>((ref) {
  return JournalRemoteDataSource(ref.watch(apiClientProvider));
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(
    remote: ref.watch(journalRemoteDataSourceProvider),
    useMock: AppConfig.useMockData,
  );
});
