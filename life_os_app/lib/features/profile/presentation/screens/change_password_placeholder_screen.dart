import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';

class ChangePasswordPlaceholderScreen extends StatelessWidget {
  const ChangePasswordPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Coming soon', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Password changes will be available in a future update. '
                'For now, use the web app or contact support if you need help.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
