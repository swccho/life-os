import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_os_app/app/app.dart';
import 'package:life_os_app/features/auth/data/models/user_model.dart';
import 'package:life_os_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:life_os_app/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:life_os_app/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:life_os_app/features/habits/presentation/providers/habits_notifier.dart';
import 'package:life_os_app/features/journal/presentation/providers/journal_notifier.dart';
import 'package:life_os_app/features/mood/presentation/providers/mood_notifier.dart';
import 'package:life_os_app/features/settings/presentation/providers/settings_notifier.dart';
import 'package:life_os_app/features/tasks/presentation/providers/tasks_notifier.dart';

class _UnauthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(sessionStatus: AuthSessionStatus.unauthenticated);
  }
}

class _AuthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState(
      sessionStatus: AuthSessionStatus.authenticated,
      user: const UserModel(id: 1, name: 'Test', email: 'test@example.com'),
    );
  }
}

class _IdleTasksNotifier extends TasksNotifier {
  @override
  TasksState build() {
    return const TasksState(
      loadStatus: TasksLoadStatus.ready,
      tasks: [],
    );
  }
}

class _IdleHabitsNotifier extends HabitsNotifier {
  @override
  HabitsState build() {
    return const HabitsState(
      loadStatus: HabitsLoadStatus.ready,
      habits: [],
    );
  }
}

class _IdleJournalNotifier extends JournalNotifier {
  @override
  JournalState build() {
    return const JournalState(
      loadStatus: JournalLoadStatus.ready,
      entries: [],
    );
  }
}

class _IdleMoodNotifier extends MoodNotifier {
  @override
  MoodState build() {
    return const MoodState(
      loadStatus: MoodLoadStatus.ready,
      logs: [],
    );
  }
}

class _IdleDashboardNotifier extends DashboardNotifier {
  @override
  DashboardState build() {
    return DashboardState(
      loadStatus: DashboardLoadStatus.ready,
      summary: DashboardSummary.mock(),
    );
  }
}

class _IdleSettingsNotifier extends SettingsNotifier {
  @override
  Future<SettingsData> build() async => const SettingsData();
}

void main() {
  testWidgets('unauthenticated → Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_UnauthenticatedAuthNotifier.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('authenticated → Dashboard screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_AuthenticatedAuthNotifier.new),
          tasksNotifierProvider.overrideWith(_IdleTasksNotifier.new),
          habitsNotifierProvider.overrideWith(_IdleHabitsNotifier.new),
          journalNotifierProvider.overrideWith(_IdleJournalNotifier.new),
          moodNotifierProvider.overrideWith(_IdleMoodNotifier.new),
          dashboardNotifierProvider.overrideWith(_IdleDashboardNotifier.new),
          settingsNotifierProvider.overrideWith(_IdleSettingsNotifier.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.textContaining('overview'), findsWidgets);
  });
}
