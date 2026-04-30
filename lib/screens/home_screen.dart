import 'package:flutter/material.dart';

import 'package:fc_learning_app/screens/quiz_screen.dart';
import 'package:fc_learning_app/services/trivia_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Open Trivia DB category id. 9 = General Knowledge, 18 = Computers, etc.
  int _selectedCategory = 9;
  bool _loading = false;

  static const List<DropdownMenuItem<int>> _categories = [
    DropdownMenuItem(value: 9, child: Text('General Knowledge')),
    DropdownMenuItem(value: 18, child: Text('Computers')),
    DropdownMenuItem(value: 23, child: Text('History')),
    DropdownMenuItem(value: 21, child: Text('Sports')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FC Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.quiz, size: 96),
            const SizedBox(height: 32),
            const Text(
              'Pick a category and test yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onStartPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Start', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onStartPressed() async {
    setState(() => _loading = true);
    try {
      final api = TriviaApi();
      final questions =
          await api.fetchQuestions(category: _selectedCategory);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(questions: questions),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
