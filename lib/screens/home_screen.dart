import 'package:flutter/material.dart';

import 'package:fc_learning_app/leaderboard/leaderboard_screen.dart';
import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/screens/quiz_screen.dart';
import 'package:fc_learning_app/services/trivia_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TriviaApi _api = TriviaApi();

  List<Category>? _categories;
  String? _categoriesError;
  int? _selectedCategory;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _categoriesError = null;
      _categories = null;
    });
    try {
      final categories = await _api.fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _selectedCategory = categories.isNotEmpty ? categories.first.id : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _categoriesError = e.toString());
    }
  }

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
            _buildCategoryField(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _canStart() ? _onStartPressed : null,
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
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _loading ? null : _onLeaderboardPressed,
              icon: const Icon(Icons.leaderboard),
              label: const Text('Leaderboard', style: TextStyle(fontSize: 18)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLeaderboardPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
    );
  }

  Widget _buildCategoryField() {
    if (_categoriesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Could not load categories: $_categoriesError',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loadCategories,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      );
    }
    if (_categories == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DropdownButtonFormField<int>(
      initialValue: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final c in _categories!)
          DropdownMenuItem(value: c.id, child: Text(c.name)),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() => _selectedCategory = value);
      },
    );
  }

  bool _canStart() =>
      !_loading && _selectedCategory != null && _categoriesError == null;

  Future<void> _onStartPressed() async {
    final categoryId = _selectedCategory;
    final categories = _categories;
    if (categoryId == null || categories == null) return;
    final categoryName =
        categories.firstWhere((c) => c.id == categoryId).name;
    setState(() => _loading = true);
    try {
      final questions = await _api.fetchQuestions(category: categoryId);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            questions: questions,
            categoryId: categoryId,
            categoryName: categoryName,
          ),
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
