import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/question.dart';
import 'package:fc_learning_app/widgets/answer_button.dart';
import 'package:fc_learning_app/widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // TODO(trainee): track quiz progress.
  //
  // You will need at least:
  //   int _currentIndex = 0;
  //   int _score = 0;
  //
  // When the user taps an answer:
  //  1. Compare the tapped label with question.correctAnswer.
  //  2. If correct, increment _score.
  //  3. If there are more questions, increment _currentIndex with setState.
  //  4. Otherwise, build a QuizResult and Navigator.pushReplacement to ResultScreen.

  @override
  Widget build(BuildContext context) {
    // Static placeholder so the screen renders even before the trainee
    // implements the state logic. They will replace this with the real one.
    final placeholder = widget.questions.isNotEmpty
        ? widget.questions.first
        : const Question(
            text: 'Placeholder question — implement state logic to see real ones.',
            correctAnswer: 'A',
            incorrectAnswers: ['B', 'C', 'D'],
            category: 'Demo',
            difficulty: 'easy',
          );
    final answers = placeholder.shuffledAnswers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '0 / ${widget.questions.length}', // TODO(trainee): real index
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            QuestionCard(text: placeholder.text),
            const SizedBox(height: 24),
            for (final answer in answers)
              AnswerButton(
                label: answer,
                onTap: () => _onAnswerTap(answer, placeholder.correctAnswer),
              ),
          ],
        ),
      ),
    );
  }

  void _onAnswerTap(String tapped, String correct) {
    // TODO(trainee): replace this stub with real progression logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tapped == correct ? 'Correct!' : 'Wrong — was $correct'),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }
}
