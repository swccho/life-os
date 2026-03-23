import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_spacing.dart';
import '../../core/widgets/app_glass_card.dart';

/// Scrollable placeholder layout for shell tabs (title, subtitle, coming-soon card).
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(title, style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppGlassCard(
                elevated: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coming soon',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We are crafting this experience with the same polish as the rest of LifeOS.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (footer != null) ...[
                const SizedBox(height: AppSpacing.xl),
                footer!,
              ],
            ]),
          ),
        ),
      ],
    );
  }
}
