import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import 'splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen<AuthState>(authNotifierProvider, (previous, next) {
    refresh.value++;
  });

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = ref.read(authNotifierProvider);
    final loc = state.uri.path;

    switch (auth.sessionStatus) {
      case AuthSessionStatus.initializing:
        if (loc == '/splash') return null;
        return '/splash';
      case AuthSessionStatus.unauthenticated:
        if (loc == '/login' || loc == '/register') return null;
        if (loc == '/splash') return '/login';
        return '/login';
      case AuthSessionStatus.authenticated:
        if (loc == '/login' || loc == '/register' || loc == '/splash') {
          return '/dashboard';
        }
        if (loc == '/dashboard') return null;
        return '/dashboard';
    }
  }

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const DashboardScreen(),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });

  return router;
});
