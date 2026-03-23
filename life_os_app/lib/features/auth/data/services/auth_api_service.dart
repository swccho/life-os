import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../../../core/network/network_exceptions.dart';
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
      throw NetworkExceptions.fromDio(e);
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
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post<Map<String, dynamic>>('/logout');
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    String? bio,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/profile',
        data: {
          'name': name,
          'bio': bio,
        },
      );
      final data = response.data!;
      ApiResponseParser.ensureSuccess(data);
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
      throw NetworkExceptions.fromDio(e);
    }
  }

  Future<UserModel> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/me');
      final data = response.data!;
      ApiResponseParser.ensureSuccess(data);
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
      throw NetworkExceptions.fromDio(e);
    }
  }

  AuthResponseModel _parseAuthResponse(Map<String, dynamic> data) {
    ApiResponseParser.ensureSuccess(data);
    final inner = data['data'] as Map<String, dynamic>?;
    if (inner == null) {
      throw ApiException('Invalid response from server.');
    }
    return AuthResponseModel.fromJson(inner);
  }
}
