import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/leaderboard_entry.dart';
import 'package:fc_learning_app/models/quiz_result.dart';
import 'package:fc_learning_app/services/leaderboard_repository.dart';
import 'package:fc_learning_app/widgets/primary_button.dart';
import 'package:fc_learning_app/widgets/secondary_button.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Icon(Icons.emoji_events, size: 96, color: theme.colorScheme.primary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                Text(
                  '${result.score} / ${result.total}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                Text(
                  result.summary,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  result.categoryName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                  ),
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
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                PrimaryButton(
                  label: 'Save',
                  loading: _saving,
                  onPressed: _canSave ? _onSavePressed : null,
                ),
                SecondaryButton(
                  label: 'Restart',
                  onPressed: _saving ? null : () => _onRestartPressed(context),
                ),
              ],
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
