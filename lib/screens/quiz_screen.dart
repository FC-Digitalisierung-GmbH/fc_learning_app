import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/question.dart';
import 'package:fc_learning_app/models/quiz_result.dart';
import 'package:fc_learning_app/screens/result_screen.dart';
import 'package:fc_learning_app/widgets/answer_button.dart';
import 'package:fc_learning_app/widgets/primary_button.dart';
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
  String? _tappedAnswer;

  @override
  void initState() {
    super.initState();
    _answers = widget.questions[_currentIndex].shuffledAnswers;
  }

  bool get _revealed => _tappedAnswer != null;

  bool get _isLastQuestion => _currentIndex + 1 >= widget.questions.length;

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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 40,
          children: [
            Flexible(child: QuestionCard(text: question.text)),
            Flexible(
              child: Center(
                child: Column(
                  children: [
                    for (final answer in _answers)
                      AnswerButton(
                        label: answer,
                        state: _stateFor(answer, question.correctAnswer),
                        onTap: _revealed ? null : () => _onAnswerTap(answer, question.correctAnswer),
                      ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              label: _isLastQuestion ? 'Finish' : 'Next',
              icon: _isLastQuestion ? Icons.flag : Icons.arrow_forward,
              onPressed: _revealed ? _onNextPressed : null,
            ),
          ],
        ),
      ),
    );
  }

  AnswerState _stateFor(String answer, String correct) {
    if (!_revealed) return AnswerState.idle;
    if (answer == _tappedAnswer) {
      return answer == correct ? AnswerState.correct : AnswerState.wrong;
    }
    if (answer == correct && _tappedAnswer != correct) {
      return AnswerState.mutedCorrect;
    }
    return AnswerState.idle;
  }

  void _onAnswerTap(String tapped, String correct) {
    if (_tappedAnswer != null) return;
    if (tapped == correct) _score++;
    setState(() => _tappedAnswer = tapped);
  }

  void _onNextPressed() {
    if (!_isLastQuestion) {
      setState(() {
        _currentIndex++;
        _answers = widget.questions[_currentIndex].shuffledAnswers;
        _tappedAnswer = null;
      });
      return;
    }
    final result = QuizResult(
      score: _score,
      total: widget.questions.length,
      finishedAt: DateTime.now(),
      categoryId: widget.categoryId,
      categoryName: widget.categoryName,
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result)));
  }
}
