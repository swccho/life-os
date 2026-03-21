import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_os_app/app/app.dart';
import 'package:life_os_app/features/auth/data/models/user_model.dart';
import 'package:life_os_app/features/auth/presentation/providers/auth_notifier.dart';

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
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.textContaining('Welcome'), findsOneWidget);
  });
}
