import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/presentation/providers/settings_notifier.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final accent = settings?.accentColor;

    return MaterialApp.router(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(accentSeed: accent),
      darkTheme: AppTheme.dark(accentSeed: accent),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
