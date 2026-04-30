import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/quiz_result.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, size: 96),
            const SizedBox(height: 24),
            Text(
              '${result.score} / ${result.total}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              result.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => _onRestartPressed(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Restart', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _onRestartPressed(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
