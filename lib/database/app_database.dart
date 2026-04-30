import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Lazily-opened singleton wrapper around the app's sqflite database.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String _fileName = 'fc_quiz.db';
  static const int _version = 1;

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, _fileName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leaderboard_entries (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        name          TEXT    NOT NULL,
        score         INTEGER NOT NULL,
        total         INTEGER NOT NULL,
        category_id   INTEGER NOT NULL,
        category_name TEXT    NOT NULL,
        finished_at   TEXT    NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_lb_cat_score
        ON leaderboard_entries(category_id, score DESC, finished_at DESC)
    ''');
  }
}
