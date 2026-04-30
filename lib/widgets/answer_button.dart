import 'package:flutter/material.dart';

/// One tappable answer on the quiz screen. Visuals come from the app theme's
/// `elevatedButtonTheme`.
class AnswerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
