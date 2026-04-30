import 'package:flutter/material.dart';

import 'package:fc_learning_app/theme/app_theme.dart';

/// Visual state of an [AnswerButton] after the user has tapped an answer.
enum AnswerState {
  /// User has not picked yet — button is tappable in the default style.
  idle,

  /// The user picked this answer and it was correct.
  correct,

  /// The user picked this answer and it was wrong.
  wrong,

  /// The user picked a different (wrong) answer; this one is the right answer.
  mutedCorrect,
}

/// One tappable answer on the quiz screen. Visuals come from the app theme's
/// `elevatedButtonTheme` for [AnswerState.idle] and from [QuizFeedbackColors]
/// for the revealed states.
class AnswerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AnswerState state;

  const AnswerButton({
    super.key,
    required this.label,
    required this.onTap,
    this.state = AnswerState.idle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedback = theme.extension<QuizFeedbackColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: _buildButton(theme, feedback),
      ),
    );
  }

  Widget _buildButton(ThemeData theme, QuizFeedbackColors feedback) {
    if (state == AnswerState.idle) {
      return ElevatedButton(
        onPressed: onTap,
        child: Text(label, textAlign: TextAlign.center),
      );
    }

    final (bg, fg, border, icon) = switch (state) {
      AnswerState.correct => (feedback.correct, feedback.onCorrect, feedback.correct, Icons.check_circle),
      AnswerState.wrong => (feedback.wrong, feedback.onWrong, feedback.wrong, Icons.cancel),
      AnswerState.mutedCorrect => (feedback.correct, feedback.onCorrect, feedback.correct, Icons.check_circle),
      AnswerState.idle => throw StateError('handled above'),
    };

    final style = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: bg,
      disabledForegroundColor: fg,
      side: BorderSide(color: border, width: 1.5),
    );

    return ElevatedButton.icon(
      onPressed: null,
      style: style,
      icon: Icon(icon, color: fg),
      label: Text(label, textAlign: TextAlign.center),
    );
  }
}
