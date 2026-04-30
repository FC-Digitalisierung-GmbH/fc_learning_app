import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/question.dart';
import 'package:fc_learning_app/models/quiz_result.dart';
import 'package:fc_learning_app/screens/result_screen.dart';
import 'package:fc_learning_app/widgets/answer_button.dart';
import 'package:fc_learning_app/widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final int categoryId;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
    _answers = widget.questions[_currentIndex].shuffledAnswers;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${widget.questions.length}',
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
            QuestionCard(text: question.text),
            const SizedBox(height: 24),
            for (final answer in _answers)
              AnswerButton(
                label: answer,
                onTap: () => _onAnswerTap(answer, question.correctAnswer),
              ),
          ],
        ),
      ),
    );
  }

  void _onAnswerTap(String tapped, String correct) {
    if (tapped == correct) _score++;
    if (_currentIndex + 1 < widget.questions.length) {
      setState(() {
        _currentIndex++;
        _answers = widget.questions[_currentIndex].shuffledAnswers;
      });
    } else {
      final result = QuizResult(
        score: _score,
        total: widget.questions.length,
        finishedAt: DateTime.now(),
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      );
    }
  }
}
