import 'package:dio/dio.dart';

import 'api_endpoint.dart';
import 'dio_local_tls.dart';

/// Factory for shared [Dio] [BaseOptions]. Interceptors are attached in [dioProvider].
class DioClient {
  DioClient._();

  static Dio create() {
    final baseUrl = resolveApiBaseUrl();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          Headers.contentTypeHeader: Headers.jsonContentType,
          Headers.acceptHeader: Headers.jsonContentType,
          ...apiExtraHeaders(),
        },
      ),
    );
    configureLocalDevTls(dio);
    return dio;
  }
}
