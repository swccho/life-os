import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../shared/providers/auth_providers.dart';
import 'api_client.dart';
import 'dio_client.dart';

/// App-wide [Dio] with JSON headers, timeouts, TLS, Bearer token, 401 handling,
/// and debug logging. Prefer [apiClientProvider] for API calls.
final dioProvider = Provider<Dio>((ref) {
  final dio = DioClient.create();
  final storage = ref.read(tokenStorageProvider);
  final container = ref.container;

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

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final path = e.requestOptions.path;
          final isAuthEndpoint =
              path.contains('/login') || path.contains('/register');
          if (!isAuthEndpoint) {
            await storage.deleteToken();
            container.read(authNotifierProvider.notifier).handleUnauthorized();
          }
        }
        return handler.next(e);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});
