import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/screens/leaderboard_screen.dart';
import 'package:fc_learning_app/screens/quiz_screen.dart';
import 'package:fc_learning_app/services/trivia_api.dart';
import 'package:fc_learning_app/widgets/category_dropdown.dart';
import 'package:fc_learning_app/widgets/primary_button.dart';
import 'package:fc_learning_app/widgets/secondary_button.dart';

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
          spacing: 48,
          children: [
            Column(
              spacing: 16,
              children: [
                Icon(Icons.quiz_outlined, size: 96, color: Theme.of(context).colorScheme.primary),
                Text(
                  'Welcome to the FC Quiz App!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                Text(
                  'Test your knowledge across various topics.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Earn points and climb the leaderboard.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            CategoryDropdown(
              categories: _categories,
              error: _categoriesError,
              selectedId: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
              onRetry: _loadCategories,
            ),
            Column(
              spacing: 16,
              children: [
                PrimaryButton(
                  label: 'Start',
                  icon: Icons.play_arrow,
                  loading: _loading,
                  onPressed: _canStart() ? _onStartPressed : null,
                ),
                SecondaryButton(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard,
                  onPressed: _loading ? null : _onLeaderboardPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLeaderboardPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
  }

  bool _canStart() => !_loading && _selectedCategory != null && _categoriesError == null;

  Future<void> _onStartPressed() async {
    final categoryId = _selectedCategory;
    final categories = _categories;
    if (categoryId == null || categories == null) return;
    final categoryName = categories.firstWhere((c) => c.id == categoryId).name;
    setState(() => _loading = true);
    try {
      final questions = await _api.fetchQuestions(category: categoryId);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(questions: questions, categoryId: categoryId, categoryName: categoryName),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load questions: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
