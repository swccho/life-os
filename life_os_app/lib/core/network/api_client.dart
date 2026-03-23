import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response_parser.dart';
import 'network_exceptions.dart';

/// Typed access to Laravel JSON envelopes via [Dio].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<(dynamic data, PageMeta? meta)> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<(dynamic data, PageMeta? meta)> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<(dynamic data, PageMeta? meta)> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<(dynamic data, PageMeta? meta)> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<(dynamic data, PageMeta? meta)> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  (dynamic data, PageMeta? meta) _unwrap(Response<dynamic> response) {
    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw ApiException(
        'Invalid response from server.',
        statusCode: response.statusCode,
        kind: ApiFailureKind.server,
      );
    }
    ApiResponseParser.ensureSuccess(body);
    return (body['data'], ApiResponseParser.parseMeta(body['meta']));
  }
}
