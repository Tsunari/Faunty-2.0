import 'package:flutter/material.dart';

/// Shows a custom snackbar with consistent styling.
void showCustomSnackBar(BuildContext context, String message, {Color? backgroundColor, Duration? duration}) {
  final messenger = ScaffoldMessenger.of(context);
  // Only allow one snackbar at a time
  if (messenger.mounted) {
    // Flutter does not support a queue count, so we clear all before showing a new one
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
