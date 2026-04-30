import 'package:fc_learning_app/models/leaderboard_entry.dart';
import 'package:fc_learning_app/services/app_database.dart';

/// Reads and writes leaderboard rows from the local sqflite database.
class LeaderboardRepository {
  Future<int> save(LeaderboardEntry entry) async {
    final db = await AppDatabase.instance.database;
    return db.insert('leaderboard_entries', entry.toMap());
  }

  Future<List<LeaderboardEntry>> findByCategory(int categoryId) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'leaderboard_entries',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'score DESC, finished_at DESC',
    );
    return rows.map(LeaderboardEntry.fromMap).toList();
  }
}
