import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/models/leaderboard_entry.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // TODO(trainee): populate from TriviaApi.fetchCategories.
  final List<Category> _categories = const [];

  // TODO(trainee): populate from LeaderboardRepository.findByCategory(selectedId).
  // Until then the list stays empty and the empty-state copy is shown.
  final List<LeaderboardEntry> _entries = const [];

  int? _selectedCategoryId;

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
        // TODO(trainee): re-query LeaderboardRepository.findByCategory(value).
      },
    );
  }

  Widget _buildEntries() {
    if (_entries.isEmpty) {
      return Center(
        child: Text(
          _categories.isEmpty
              ? 'Pick a category to see scores.'
              : 'No scores yet. Be the first!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return ListView.separated(
      itemCount: _entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = _entries[index];
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
  }
}
