import 'package:flutter/material.dart';

import '../../app/theme/tokens/app_colors.dart';

/// Returns `true` if the user confirmed (tapped **Yes**).
Future<bool> showDeleteConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  return result == true;
}
