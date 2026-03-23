import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../shared/providers/auth_providers.dart';
import '../../data/models/user_model.dart';
import 'auth_repository_provider.dart';

enum AuthSessionStatus {
  initializing,
  authenticated,
  unauthenticated,
}

class AuthState {
  const AuthState({
    this.sessionStatus = AuthSessionStatus.initializing,
    this.user,
    this.errorMessage,
    this.isBusy = false,
  });

  final AuthSessionStatus sessionStatus;
  final UserModel? user;
  final String? errorMessage;
  final bool isBusy;

  AuthState copyWith({
    AuthSessionStatus? sessionStatus,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
    bool? isBusy,
  }) {
    return AuthState(
      sessionStatus: sessionStatus ?? this.sessionStatus,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(_bootstrap);
    return const AuthState(sessionStatus: AuthSessionStatus.initializing);
  }

  Future<void> _bootstrap() async {
    final token = await ref.read(tokenStorageProvider).getToken();
    if (token == null || token.isEmpty) {
      state = const AuthState(sessionStatus: AuthSessionStatus.unauthenticated);
      return;
    }
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      state = AuthState(sessionStatus: AuthSessionStatus.authenticated, user: user);
    } on ApiException catch (_) {
      await ref.read(tokenStorageProvider).deleteToken();
      state = const AuthState(sessionStatus: AuthSessionStatus.unauthenticated);
    } catch (_) {
      await ref.read(tokenStorageProvider).deleteToken();
      state = const AuthState(sessionStatus: AuthSessionStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final user = await ref.read(authRepositoryProvider).login(
            email: email,
            password: password,
          );
      state = AuthState(sessionStatus: AuthSessionStatus.authenticated, user: user);
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final user = await ref.read(authRepositoryProvider).register(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          );
      state = AuthState(sessionStatus: AuthSessionStatus.authenticated, user: user);
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      await ref.read(authRepositoryProvider).logout();
    } finally {
      state = const AuthState(
        sessionStatus: AuthSessionStatus.unauthenticated,
        isBusy: false,
      );
    }
  }

  /// Clears session after 401 from the API (token already removed by interceptor).
  void handleUnauthorized() {
    state = const AuthState(
      sessionStatus: AuthSessionStatus.unauthenticated,
      isBusy: false,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// After a successful profile API update, sync the in-memory user.
  void applyUpdatedUser(UserModel user) {
    if (state.sessionStatus != AuthSessionStatus.authenticated) return;
    state = state.copyWith(user: user);
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
