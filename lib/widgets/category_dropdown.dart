import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/category.dart';
import 'package:fc_learning_app/widgets/error_retry.dart';

/// Dropdown for choosing a trivia category. Handles its own loading and error
/// states so callers only pass raw data + callbacks.
class CategoryDropdown extends StatelessWidget {
  final List<Category>? categories;
  final String? error;
  final int? selectedId;
  final ValueChanged<int> onChanged;
  final VoidCallback onRetry;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.error,
    required this.selectedId,
    required this.onChanged,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return ErrorRetry(message: 'Could not load categories: $error', onRetry: onRetry);
    }
    if (categories == null) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: CircularProgressIndicator()),
      );
    }
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Category'),
      items: [for (final c in categories!) DropdownMenuItem(value: c.id, child: Text(c.name))],
      onChanged: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}
