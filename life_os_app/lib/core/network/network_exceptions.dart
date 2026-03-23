import 'package:dio/dio.dart';

import 'api_exception.dart';

abstract final class NetworkExceptions {
  static ApiException fromDio(DioException e) {
    final response = e.response;
    final code = response?.statusCode;

    if (code == 401) {
      return ApiException(
        'Your session expired. Please sign in again.',
        statusCode: code,
        kind: ApiFailureKind.unauthorized,
      );
    }
    if (code == 409) {
      final msg = _messageFromResponse(response) ??
          'This action conflicts with existing data.';
      return ApiException(
        msg,
        statusCode: code,
        kind: ApiFailureKind.conflict,
      );
    }
    if (code == 422) {
      if (response?.data is Map<String, dynamic>) {
        return ApiException.fromErrorBody(response!.data as Map<String, dynamic>)
            .copyWith(statusCode: code, kind: ApiFailureKind.validation);
      }
    }
    if (code != null && code >= 500) {
      return ApiException(
        'Something went wrong on our end. Please try again later.',
        statusCode: code,
        kind: ApiFailureKind.server,
      );
    }

    if (response?.data is Map<String, dynamic>) {
      final map = response!.data as Map<String, dynamic>;
      final success = map['success'] as bool?;
      if (success == false) {
        return ApiException.fromErrorBody(map).copyWith(statusCode: code);
      }
      final message = _messageFromResponse(response);
      if (message != null) {
        return ApiException(message, statusCode: code);
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        'Connection timed out. Check your network.',
        statusCode: code,
        kind: ApiFailureKind.timeout,
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        'Could not reach the server. Check your connection.',
        statusCode: code,
        kind: ApiFailureKind.network,
      );
    }

    return ApiException(
      e.message?.isNotEmpty == true
          ? e.message!
          : 'Something went wrong. Please try again.',
      statusCode: code,
      kind: ApiFailureKind.unknown,
    );
  }

  static String? _messageFromResponse(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final m = data['message'] as String?;
      if (m != null && m.isNotEmpty) return m;
    }
    return null;
  }
}
