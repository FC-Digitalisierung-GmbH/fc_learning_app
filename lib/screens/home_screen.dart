import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO(trainee): populate this with categories from TriviaApi.fetchCategories.
  // Until then the dropdown stays empty and disabled.
  final List<Category> _categories = const [];

  int? _selectedCategoryId;
  // ignore: prefer_final_fields
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FC Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            const Icon(Icons.quiz_outlined, size: 96),
            const Text(
              'Pick a category and test yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            _buildCategoryField(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _selectedCategoryId == null ? null : _onStartPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Start', style: TextStyle(fontSize: 18)),
                ),
                OutlinedButton.icon(
                  onPressed: _onLeaderboardPressed,
                  icon: const Icon(Icons.leaderboard),
                  label:
                      const Text('Leaderboard', style: TextStyle(fontSize: 18)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    if (_categories.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
          enabled: false,
        ),
        child: const Text(
          'No categories',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }
    return DropdownButtonFormField<int>(
      initialValue: _selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final c in _categories)
          DropdownMenuItem(value: c.id, child: Text(c.name)),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedCategoryId = value);
      },
    );
  }

  void _onStartPressed() {
    // TODO(trainee): wire the Start button.
    //
    // Steps:
    //  1. Look up the selected Category (id + name) from _categories.
    //  2. setState(() => _loading = true) so the spinner shows.
    //  3. Call TriviaApi().fetchQuestions(category: id).
    //  4. Navigator.push to QuizScreen with questions, categoryId, categoryName.
    //  5. Reset _loading in a finally block.
    //  6. On error, show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Start button')),
    );
  }

  void _onLeaderboardPressed() {
    // TODO(trainee): Navigator.push to LeaderboardScreen.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Leaderboard button')),
    );
  }
}
