import 'package:flutter/material.dart';

import 'package:fc_learning_app/widgets/secondary_button.dart';

/// Error message with a retry button — used wherever a fetch can fail.
class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetry({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        SecondaryButton(onPressed: onRetry, icon: Icons.refresh, label: 'Retry'),
      ],
    );
  }
}
