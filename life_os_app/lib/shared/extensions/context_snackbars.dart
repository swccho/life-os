import 'package:flutter/material.dart';

extension AppSnackbars on BuildContext {
  void showAppSnackBar(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(this);
    final scheme = Theme.of(this).colorScheme;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: isError
              ? TextStyle(color: scheme.onError)
              : null,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? scheme.error : null,
      ),
    );
  }
}
