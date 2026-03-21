import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return _parseAuthResponse(response.data!);
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'email': email, 'password': password},
      );
      return _parseAuthResponse(response.data!);
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post<Map<String, dynamic>>('/logout');
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  Future<UserModel> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/me');
      final data = response.data!;
      _ensureSuccess(data);
      final inner = data['data'] as Map<String, dynamic>?;
      if (inner == null) {
        throw ApiException('Invalid response from server.');
      }
      final userJson = inner['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw ApiException('Invalid response from server.');
      }
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  AuthResponseModel _parseAuthResponse(Map<String, dynamic> data) {
    _ensureSuccess(data);
    final inner = data['data'] as Map<String, dynamic>?;
    if (inner == null) {
      throw ApiException('Invalid response from server.');
    }
    return AuthResponseModel.fromJson(inner);
  }

  void _ensureSuccess(Map<String, dynamic> data) {
    final success = data['success'] as bool?;
    if (success == false) {
      final message = data['message'] as String? ?? 'Request failed';
      throw ApiException(message);
    }
  }

  static ApiException _mapDio(DioException e) {
    final response = e.response;
    if (response?.data is Map<String, dynamic>) {
      final map = response!.data as Map<String, dynamic>;
      final message = map['message'] as String?;
      if (message != null && message.isNotEmpty) {
        final errors = map['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return ApiException(
              first.first as String,
              statusCode: response.statusCode,
            );
          }
        }
        return ApiException(message, statusCode: response.statusCode);
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        'Connection timed out. Check your network.',
        statusCode: statusCodeFrom(e),
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        'Could not reach the API server. Ensure Laragon is running and '
        'AppConfig.apiPublicBaseUrl is correct. On a physical phone, try '
        '--dart-define=LIFE_OS_API_BASE_URL=https://life-os.test/api',
        statusCode: statusCodeFrom(e),
      );
    }
    return ApiException(
      e.message ?? 'Something went wrong.',
      statusCode: statusCodeFrom(e),
    );
  }

  static int? statusCodeFrom(DioException e) => e.response?.statusCode;
}
