import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'logger.dart';

/// Mostra un missatge d'error
void showErrorMessage(
  BuildContext context,
  String message, [
  Object? error,
]) {
  log(error);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppStyles.text.medium.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  });
}
