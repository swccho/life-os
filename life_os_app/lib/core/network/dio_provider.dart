import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/auth_providers.dart';
import 'dio_client.dart';

/// App-wide [Dio] with JSON headers, timeouts, and Bearer token from [tokenStorageProvider].
final dioProvider = Provider<Dio>((ref) {
  final dio = DioClient.create();
  final storage = ref.read(tokenStorageProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  ref.onDispose(dio.close);
  return dio;
});
