import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_screen_background.dart';
import 'widgets/app_bottom_nav_bar.dart';

/// Authenticated app shell: immersive background, tab body, custom bottom nav.
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: Column(
          children: [
            Expanded(child: navigationShell),
            AppBottomNavBar(navigationShell: navigationShell),
          ],
        ),
      ),
    );
  }
}
