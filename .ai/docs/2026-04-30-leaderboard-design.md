---
tags: [design, leaderboard, sqflite]
created: 2026-04-30
project_path: /home/nosa/FC-Group/FC-Projects/fc_learning_app
---

# Leaderboard Feature — Design

## Goal

Persist quiz results locally, display them per category. User on the Result
screen enters a name and saves their score. A new Leaderboard screen lists
saved entries filtered by a chosen category.

## Scope

- Result screen: name TextField (3–20 chars trimmed) + Save button. Save
  persists `{name, score, total, categoryId, categoryName, finishedAt}` and
  pops to Home. Restart button stays.
- Home screen: Leaderboard button below Start.
- Leaderboard screen: category dropdown (same UX as Home, fetched from API)
  + ListView of entries for that category, sorted score DESC then date DESC.
- Local database: `sqflite`.

## Out of scope

- Editing / deleting entries
- Top-N cap, dedup by name
- Cloud sync, multi-device
- Schema migrations (single v1)
- Tests (consistent with rest of project)

## Architecture

Feature-module layout per AGENTS.md.

```
lib/
  database/
    app_database.dart           # sqflite singleton, table init
  leaderboard/
    leaderboard_entry.dart      # model + toMap/fromMap
    leaderboard_repository.dart # save, findByCategory
    leaderboard_screen.dart     # UI
  models/
    quiz_result.dart            # +categoryId, +categoryName
  screens/
    home_screen.dart            # +Leaderboard button
    quiz_screen.dart            # +categoryId, +categoryName ctor params
    result_screen.dart          # rewritten Stateful + TextField + Save
```

## Data layer

`AppDatabase` is a singleton holding a lazy-opened `Database`. First access
runs `onCreate` which executes the DDL below.

```sql
CREATE TABLE leaderboard_entries (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT    NOT NULL,
  score         INTEGER NOT NULL,
  total         INTEGER NOT NULL,
  category_id   INTEGER NOT NULL,
  category_name TEXT    NOT NULL,
  finished_at   TEXT    NOT NULL  -- ISO-8601 local
);
CREATE INDEX idx_lb_cat_score
  ON leaderboard_entries(category_id, score DESC, finished_at DESC);
```

DB version: 1. No migrations defined.

`LeaderboardEntry`:

```dart
class LeaderboardEntry {
  final int? id;
  final String name;
  final int score;
  final int total;
  final int categoryId;
  final String categoryName;
  final DateTime finishedAt;

  Map<String, Object?> toMap();
  factory LeaderboardEntry.fromMap(Map<String, Object?> map);
}
```

`LeaderboardRepository`:

- `Future<int> save(LeaderboardEntry entry)` — INSERT, returns row id
- `Future<List<LeaderboardEntry>> findByCategory(int categoryId)` — query
  with `WHERE category_id = ? ORDER BY score DESC, finished_at DESC`

Repository instances are constructed where used (no DI). They internally
await `AppDatabase.instance.database`.

## Threading category through quiz flow

`QuizResult` gains `categoryId` and `categoryName`.

`QuizScreen` ctor adds `int categoryId, String categoryName`.

`HomeScreen` already knows both: the selected dropdown ID and the matching
`Category.name` from its in-memory list. It passes them to `QuizScreen`,
which forwards them to `QuizResult` when navigating to `ResultScreen`.

## UI changes

### HomeScreen

- Adds an `OutlinedButton.icon(Icons.leaderboard, "Leaderboard")` directly
  below the existing `Start` button, separated by an 8px gap.
- Tap pushes `LeaderboardScreen`.

### ResultScreen

- Now StatefulWidget.
- Body shows: trophy icon, `score / total`, summary line, category name,
  then a `TextField` and two buttons (`Save`, `Restart`).
- `TextField` config: `maxLength: 20`, `labelText: "Your name"`,
  `TextInputAction.done`. Controller in state.
- `Save` enabled iff `name.trim().length` is in `[3, 20]`. On press:
  build `LeaderboardEntry`, call `repo.save`. On success
  `Navigator.popUntil(first)`. On error show SnackBar.
- `Restart` always enabled, calls `popUntil(first)`.

### LeaderboardScreen

- StatefulWidget. State: `List<Category>? categories`, `String? categoriesError`,
  `int? selectedCategoryId`, `Future<List<LeaderboardEntry>>? entriesFuture`.
- `initState` calls `_loadCategories`. On success, sets selected to
  `categories.first.id`, kicks off entries load.
- Changing dropdown: setState selectedCategoryId, replace entriesFuture.
- Body:
  - Category dropdown (same shape as HomeScreen) — loading spinner / error+retry / dropdown
  - Below: `FutureBuilder<List<LeaderboardEntry>>` rendering:
    - waiting → CircularProgressIndicator
    - error → red text + Retry
    - empty → centered "No scores yet for {category}. Be the first!"
    - non-empty → ListView.separated of `ListTile(leading: '#${i+1}',
      title: name, subtitle: yyyy-MM-dd HH:mm, trailing: '$score / $total')`

## Error handling

| Failure | Surface |
|---|---|
| Categories API fails on Leaderboard | red text + Retry button (same UX as Home) |
| DB open fails | exception bubbles → SnackBar / error UI |
| Save fails on Result | SnackBar, user remains on screen |
| Repository read fails | FutureBuilder error branch + Retry |

## Dependencies

Add to `pubspec.yaml`:

```yaml
sqflite: ^2.3.3
path: ^1.9.0
intl: ^0.19.0   # date formatting yyyy-MM-dd HH:mm
```

## Lifecycle

- `AppDatabase` lazy-opens on first `instance.database` await. No
  `main.dart` change needed.
- `WidgetsFlutterBinding.ensureInitialized()` is implicitly handled because
  the first DB call always happens after the framework is up (button tap).

## Conventions / deviations

- Routing stays `Navigator.push` (AGENTS.md mentions go_router but app
  currently doesn't use it; introducing it is out of scope here).
- No tests, consistent with project.
- All English. Date format `yyyy-MM-dd HH:mm` local time via `intl`.
