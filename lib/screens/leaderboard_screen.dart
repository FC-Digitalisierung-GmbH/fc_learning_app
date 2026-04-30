import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/models/leaderboard_entry.dart';
import 'package:fc_learning_app/services/leaderboard_repository.dart';
import 'package:fc_learning_app/services/trivia_api.dart';
import 'package:fc_learning_app/widgets/category_dropdown.dart';
import 'package:fc_learning_app/widgets/error_retry.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  final TriviaApi _api = TriviaApi();
  final LeaderboardRepository _repo = LeaderboardRepository();

  List<Category>? _categories;
  String? _categoriesError;
  int? _selectedCategoryId;
  Future<List<LeaderboardEntry>>? _entriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _categoriesError = null;
      _categories = null;
      _selectedCategoryId = null;
      _entriesFuture = null;
    });
    try {
      final categories = await _api.fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        if (categories.isNotEmpty) {
          _selectedCategoryId = categories.first.id;
          _entriesFuture = _repo.findByCategory(categories.first.id);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _categoriesError = e.toString());
    }
  }

  void _onCategoryChanged(int value) {
    setState(() {
      _selectedCategoryId = value;
      _entriesFuture = _repo.findByCategory(value);
    });
  }

  String get _selectedCategoryName {
    final id = _selectedCategoryId;
    final list = _categories;
    if (id == null || list == null) return '';
    return list.firstWhere((c) => c.id == id, orElse: () => list.first).name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            CategoryDropdown(
              categories: _categories,
              error: _categoriesError,
              selectedId: _selectedCategoryId,
              onChanged: _onCategoryChanged,
              onRetry: _loadCategories,
            ),
            Expanded(child: _buildEntries()),
          ],
        ),
      ),
    );
  }

  Widget _buildEntries() {
    final future = _entriesFuture;
    if (future == null) return const SizedBox.shrink();
    return FutureBuilder<List<LeaderboardEntry>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: ErrorRetry(
              message: 'Could not load scores: ${snapshot.error}',
              onRetry: () {
                final id = _selectedCategoryId;
                if (id == null) return;
                setState(() => _entriesFuture = _repo.findByCategory(id));
              },
            ),
          );
        }
        final entries = snapshot.data ?? const <LeaderboardEntry>[];
        if (entries.isEmpty) {
          return Center(
            child: Text(
              'No scores yet for $_selectedCategoryName. Be the first!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return ListView.separated(
          itemCount: entries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final entry = entries[index];
            final theme = Theme.of(context);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                child: Text('${index + 1}'),
              ),
              title: Text(entry.name),
              subtitle: Text(_dateFormat.format(entry.finishedAt.toLocal())),
              trailing: Text(
                '${entry.score} / ${entry.total}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          },
        );
      },
    );
  }
}
