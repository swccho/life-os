import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/habits/presentation/screens/add_habit_screen.dart';
import '../../features/habits/presentation/screens/habit_detail_screen.dart';
import '../../features/habits/presentation/screens/habits_screen.dart';
import '../../features/journal/presentation/screens/add_journal_entry_screen.dart';
import '../../features/journal/presentation/screens/journal_entry_detail_screen.dart';
import '../../features/journal/presentation/screens/journal_home_screen.dart';
import '../../features/mood/presentation/screens/mood_history_screen.dart';
import '../../features/profile/presentation/screens/change_password_placeholder_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/legal_document_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/app_shell_scaffold.dart';
import '../../features/tasks/presentation/screens/add_task_screen.dart';
import '../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import 'app_route_transitions.dart';
import 'splash_screen.dart';

const String _appShellPrefix = '/app/';
const String _appDashboard = '/app/dashboard';

const String _aboutLifeOsBody =
    'LifeOS brings your tasks, habits, journal, and mood into one calm, premium '
    'experience. Built as a launch-ready productivity companion — focused on clarity, '
    'rhythm, and momentum without noise.';

const String _privacyPlaceholderBody =
    'This is placeholder copy. A full privacy policy will describe what data LifeOS '
    'collects, how it is used, and your choices. Replace this text before shipping to '
    'production users.';

const String _termsPlaceholderBody =
    'This is placeholder copy. Terms of use will outline acceptable use, account '
    'responsibilities, and limitations. Replace this text before shipping to production '
    'users.';

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
        if (loc.startsWith(_appShellPrefix)) return '/login';
        if (loc == '/login' || loc == '/register') return null;
        if (loc == '/splash') return '/login';
        return '/login';
      case AuthSessionStatus.authenticated:
        if (loc == '/login' ||
            loc == '/register' ||
            loc == '/splash' ||
            loc == '/dashboard') {
          return _appDashboard;
        }
        if (loc == '/app' || loc == '/app/') return _appDashboard;
        if (loc.startsWith(_appShellPrefix)) return null;
        return _appDashboard;
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
        pageBuilder: (BuildContext context, GoRouterState state) =>
            authFlowPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            authFlowPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) =>
            AppShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: _appDashboard,
                name: 'app_dashboard',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/tasks',
                name: 'app_tasks',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const TasksScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'app_tasks_add',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const AddTaskScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'task/:taskId',
                    name: 'app_tasks_detail',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: TaskDetailScreen(
                        taskId: state.pathParameters['taskId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/habits',
                name: 'app_habits',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HabitsScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'app_habits_add',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const AddHabitScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'habit/:habitId',
                    name: 'app_habits_detail',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: HabitDetailScreen(
                        habitId: state.pathParameters['habitId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/journal',
                name: 'app_journal',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const JournalHomeScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'app_journal_add',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const AddJournalEntryScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'entry/:entryId',
                    name: 'app_journal_entry_detail',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: JournalEntryDetailScreen(
                        entryId: state.pathParameters['entryId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'mood/history',
                    name: 'app_journal_mood_history',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const MoodHistoryScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/profile',
                name: 'app_profile',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'app_profile_edit',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const EditProfileScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'settings',
                    name: 'app_profile_settings',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const SettingsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: 'app_profile_change_password',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const ChangePasswordPlaceholderScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'about',
                    name: 'app_profile_about',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const LegalDocumentScreen(
                        title: 'About LifeOS',
                        body: _aboutLifeOsBody,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'privacy',
                    name: 'app_profile_privacy',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const LegalDocumentScreen(
                        title: 'Privacy',
                        body: _privacyPlaceholderBody,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'terms',
                    name: 'app_profile_terms',
                    pageBuilder: (context, state) => slideFromEndPage(
                      key: state.pageKey,
                      child: const LegalDocumentScreen(
                        title: 'Terms',
                        body: _termsPlaceholderBody,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });

  return router;
});
