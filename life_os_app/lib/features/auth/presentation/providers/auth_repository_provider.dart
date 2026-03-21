import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/auth_providers.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_api_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiServiceProvider),
    ref.watch(tokenStorageProvider),
  );
});
