import 'package:flutter/material.dart';

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

  final TextEditingController _nameController = TextEditingController();
  // ignore: prefer_final_fields
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
          spacing: 16,
          children: [
            const Icon(Icons.emoji_events, size: 96),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                Text(
                  '${result.score} / ${result.total}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Text(
                  result.summary,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  result.categoryName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
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
                OutlinedButton(
                  onPressed: _saving ? null : _onRestartPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Restart', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSavePressed() {
    // TODO(trainee): persist the result, then go back to HomeScreen.
    //
    // Steps:
    //  1. Build a LeaderboardEntry from widget.result + _nameController.text.trim().
    //  2. Call LeaderboardRepository().save(entry).
    //  3. Navigator.popUntil(context, (route) => route.isFirst).
    //  4. Show a SnackBar on error.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Save button')),
    );
  }

  void _onRestartPressed() {
    // TODO(trainee): Navigator.popUntil(context, (route) => route.isFirst).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Restart button')),
    );
  }
}
