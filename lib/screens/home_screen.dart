import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Open Trivia DB category id. 9 = General Knowledge, 18 = Computers, etc.
  int _selectedCategory = 9;

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
              child: const Text('Start', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartPressed() {
    // TODO(trainee): wire the start button.
    //
    // Steps:
    //  1. Create a TriviaApi() instance.
    //  2. Call fetchQuestions(category: _selectedCategory).
    //  3. While loading, show a CircularProgressIndicator (hint: a bool field
    //     `_loading` plus setState).
    //  4. On success, Navigator.push to QuizScreen with the questions list.
    //  5. On error, show a SnackBar with the error message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Start button')),
    );
  }
}
