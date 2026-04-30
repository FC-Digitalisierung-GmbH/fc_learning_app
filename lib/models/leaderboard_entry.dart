/// A saved leaderboard row.
class LeaderboardEntry {
  final int? id;
  final String name;
  final int score;
  final int total;
  final int categoryId;
  final String categoryName;
  final DateTime finishedAt;

  const LeaderboardEntry({
    this.id,
    required this.name,
    required this.score,
    required this.total,
    required this.categoryId,
    required this.categoryName,
    required this.finishedAt,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'score': score,
      'total': total,
      'category_id': categoryId,
      'category_name': categoryName,
      'finished_at': finishedAt.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, Object?> map) {
    return LeaderboardEntry(
      id: map['id'] as int?,
      name: map['name'] as String,
      score: map['score'] as int,
      total: map['total'] as int,
      categoryId: map['category_id'] as int,
      categoryName: map['category_name'] as String,
      finishedAt: DateTime.parse(map['finished_at'] as String),
    );
  }
}
