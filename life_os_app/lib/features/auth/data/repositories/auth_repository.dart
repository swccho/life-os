import '../../../../core/network/api_exception.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import '../../../../core/storage/token_storage.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final AuthApiService _api;
  final TokenStorage _storage;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await _api.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    await _storage.saveToken(res.token);
    return res.user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.login(email: email, password: password);
    await _storage.saveToken(res.token);
    return res.user;
  }

  /// Calls the API if possible, then always clears the local token.
  Future<void> logout() async {
    try {
      await _api.logout();
    } on ApiException {
      // Expired or invalid token — still clear locally.
    }
    await _storage.deleteToken();
  }

  Future<UserModel> getCurrentUser() => _api.me();
}
