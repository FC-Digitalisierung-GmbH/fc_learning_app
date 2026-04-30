import 'package:flutter/material.dart';

import 'package:fc_learning_app/leaderboard/leaderboard_entry.dart';
import 'package:fc_learning_app/leaderboard/leaderboard_repository.dart';
import 'package:fc_learning_app/models/quiz_result.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const int _minName = 3;
  static const int _maxName = 20;

  final LeaderboardRepository _repo = LeaderboardRepository();
  final TextEditingController _nameController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_saving) return false;
    final length = _nameController.text.trim().length;
    return length >= _minName && length <= _maxName;
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, size: 96),
            const SizedBox(height: 16),
            Text(
              '${result.score} / ${result.total}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              result.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              result.categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              maxLength: _maxName,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Your name',
                helperText: 'Between 3 and 20 characters',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _canSave ? _onSavePressed : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _saving ? null : () => _onRestartPressed(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Restart', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    final result = widget.result;
    final entry = LeaderboardEntry(
      name: _nameController.text.trim(),
      score: result.score,
      total: result.total,
      categoryId: result.categoryId,
      categoryName: result.categoryName,
      finishedAt: result.finishedAt,
    );
    setState(() => _saving = true);
    try {
      await _repo.save(entry);
      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      setState(() => _saving = false);
    }
  }

  void _onRestartPressed(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
