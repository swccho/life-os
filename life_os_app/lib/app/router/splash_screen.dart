import 'package:flutter/material.dart';

import '../../core/widgets/app_screen_background.dart';
import '../theme/tokens/app_spacing.dart';

const _logoAsset = 'assets/branding/life-os-logo.png';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _logoAsset,
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'LifeOS',
                style: textTheme.displayMedium?.copyWith(
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
