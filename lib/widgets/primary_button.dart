import 'package:flutter/material.dart';

/// Full-width primary action button.
///
/// Pulls colors and shape from the app's `elevatedButtonTheme`. Pass `loading`
/// to swap the label for a spinner while keeping the button non-interactive.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = loading ? null : onPressed;
    final spinner = SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: icon != null && !loading
          ? ElevatedButton.icon(
              onPressed: effectiveOnPressed,
              icon: Icon(icon),
              label: Text(label),
            )
          : ElevatedButton(
              onPressed: effectiveOnPressed,
              child: loading ? spinner : Text(label),
            ),
    );
  }
}
