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
    // TODO(trainee): handle a tapped answer.
    //
    //   1. If `tapped` equals `correct`, increase `_score` by 1.
    //   2. If there is still another question left:
    //        - advance `_currentIndex` to the next question
    //        - refresh `_answers` from the new question's `shuffledAnswers`
    //        - remember: changes to state fields the UI reads must happen
    //          inside `setState(() { ... })` so the screen rebuilds
    //        - then return, so the finish methode doesn't also run
    //   3. Otherwise (no more questions left), call `_onQuizFinished()`.
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
