import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fc_learning_app/leaderboard/leaderboard_entry.dart';
import 'package:fc_learning_app/leaderboard/leaderboard_repository.dart';
import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/services/trivia_api.dart';

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

  void _onCategoryChanged(int? value) {
    if (value == null) return;
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
          children: [
            _buildCategoryField(),
            const SizedBox(height: 16),
            Expanded(child: _buildEntries()),
          ],
        ),
      ),
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
      initialValue: _selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final c in _categories!)
          DropdownMenuItem(value: c.id, child: Text(c.name)),
      ],
      onChanged: _onCategoryChanged,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Could not load scores: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  final id = _selectedCategoryId;
                  if (id == null) return;
                  setState(() => _entriesFuture = _repo.findByCategory(id));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          );
        }
        final entries = snapshot.data ?? const <LeaderboardEntry>[];
        if (entries.isEmpty) {
          return Center(
            child: Text(
              'No scores yet for $_selectedCategoryName. Be the first!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return ListView.separated(
          itemCount: entries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
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
