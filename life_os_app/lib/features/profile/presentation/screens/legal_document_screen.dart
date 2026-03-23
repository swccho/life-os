import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_spacing.dart';

/// Simple scrollable copy for About / Privacy / Terms placeholders.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          body,
          style: textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ),
    );
  }
}
