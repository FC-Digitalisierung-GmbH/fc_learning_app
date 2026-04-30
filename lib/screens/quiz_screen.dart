import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/question.dart';
import 'package:fc_learning_app/widgets/answer_button.dart';
import 'package:fc_learning_app/widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final int categoryId;
  final String categoryName;

  const QuizScreen({super.key, required this.questions, required this.categoryId, required this.categoryName});

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
              child: Text('${_currentIndex + 1} / ${widget.questions.length}', style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 24,
          children: [
            Flexible(child: QuestionCard(text: question.text)),
            Flexible(
              child: Center(
                child: Column(
                  children: [
                    for (final answer in _answers)
                      AnswerButton(label: answer, onTap: () => _onAnswerTap(answer, question.correctAnswer)),
                  ],
                ),
              ),
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
      return;
    }
    _onQuizFinished();
  }

  void _onQuizFinished() {
    // TODO(trainee): build a QuizResult and Navigator.pushReplacement to ResultScreen.
    //
    //   final result = QuizResult(
    //     score: ...,
    //     total: ...,
    //     finishedAt: ...,
    //     categoryId: ...,
    //     categoryName: ...,
    //   );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('TODO(trainee): wire ResultScreen — score $_score / ${widget.questions.length}')),
    );
  }
}
