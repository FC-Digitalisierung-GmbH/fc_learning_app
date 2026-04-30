---
tags: [plan, trainee, flutter, quiz-app]
created: 2026-04-30
project_path: /home/nosa/FC-Group/FC-Projects/fc-learning-app
---

# FC Quiz App Scaffold — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Flutter scaffold (Quiz App) that a 16-year-old Realschule trainee can pick up on Day 2 of a 1-week internship. Scaffold must compile and run on Day 1 with placeholder UI and clearly-marked `// TODO(trainee):` sections. Plus: 2 bug-hunt branches with planted bugs for Day 4 debugger exercise.

**Architecture:**
- Flutter app (Android-first, iOS folder kept for later) using `setState` for state management. Single-package layout: `models`, `services`, `screens`, `widgets`. HTTP via the `http` package against the Open Trivia DB. No tests (deliberate — trainee focus is wiring + UI).
- Two deliverables: (a) `main` branch = scaffold trainee starts from, (b) `bug/easy` + `bug/medium` + optional `bug/hard` branches off a private `bug-base` branch that contains a complete reference implementation seeded with planted bugs.

**Tech Stack:**
- Flutter 3.41.2 (already installed)
- Dart 3.11.0
- Packages: `http: ^1.2.2`, `html_unescape: ^2.0.0`
- Target: Android API 34 emulator (Pixel 7)
- Repo: existing dir `/home/nosa/FC-Group/FC-Projects/fc-learning-app` (already `flutter create`d)
- Language: English only

**Project conventions:**
- Package name in `pubspec.yaml` is whatever `flutter create` produced — do NOT rename. Run `head -3 pubspec.yaml` once at the start and use that exact `name:` everywhere imports appear (`package:<name>/...`). The plan below assumes `fc_learning_app`; substitute if different.
- All file paths below are absolute under `/home/nosa/FC-Group/FC-Projects/fc-learning-app/` (referred to as `<root>` from here on).
- Commit after every task. Conventional Commits style (`feat:`, `chore:`, `docs:`, `bug:`).

---

## File Structure

```
<root>/
├── README.md                       # Modify (Task 2)
├── .gitignore                      # Already exists
├── pubspec.yaml                    # Modify — add http, html_unescape (Task 1)
├── lib/
│   ├── main.dart                   # Modify — MaterialApp + home route (Task 3)
│   ├── models/
│   │   ├── question.dart           # Create — class with fields, TODO fromJson (Task 4)
│   │   └── quiz_result.dart        # Create — done (Task 5)
│   ├── services/
│   │   └── trivia_api.dart         # Create — stub: signatures + TODO body (Task 6)
│   ├── screens/
│   │   ├── home_screen.dart        # Create — basic UI, TODO start wiring (Task 8)
│   │   ├── quiz_screen.dart        # Create — basic UI, TODO state logic (Task 9)
│   │   └── result_screen.dart      # Create — basic UI, TODO restart wiring (Task 10)
│   └── widgets/
│       ├── answer_button.dart      # Create — done (Task 7a)
│       └── question_card.dart      # Create — done (Task 7b)
├── mockups/
│   └── README.md                   # Create — placeholder for Figma exports (Task 11)
└── ios/                            # Exists from flutter create — not touched in this plan
```

**Responsibilities:**
- `main.dart` — app entry, theme, sets `HomeScreen` as initial route
- `models/question.dart` — single quiz question (text, correct, distractors, category)
- `models/quiz_result.dart` — final score record (score, total, timestamp)
- `services/trivia_api.dart` — Open Trivia DB client (stubbed for trainee)
- `screens/home_screen.dart` — entry screen: title, category dropdown, start button
- `screens/quiz_screen.dart` — question display + answer buttons + score
- `screens/result_screen.dart` — score summary + restart button
- `widgets/answer_button.dart` — reusable tappable answer
- `widgets/question_card.dart` — wraps question text in styled container

---

## Phase 1 — Scaffold (Tasks 1–12) — pushed to `main`

### Task 1: Add dependencies to pubspec.yaml

**Files:**
- Modify: `<root>/pubspec.yaml`

- [ ] **Step 1: Read current pubspec.yaml**

Run: `cat <root>/pubspec.yaml`
Expected: `name: fc_learning_app` (or similar) and a `dependencies:` block with `flutter:` and `cupertino_icons`.

- [ ] **Step 2: Add http + html_unescape to dependencies**

In `pubspec.yaml`, locate the `dependencies:` block and add the two packages directly under `cupertino_icons`. Final block should look like:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.2
  html_unescape: ^2.0.0
```

- [ ] **Step 3: Fetch packages**

Run: `cd <root> && flutter pub get`
Expected: `Got dependencies!` (no errors). Lockfile `pubspec.lock` updated.

- [ ] **Step 4: Verify project still builds**

Run: `cd <root> && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
cd <root>
git add pubspec.yaml pubspec.lock
git commit -m "chore: add http and html_unescape deps"
```

---

### Task 2: Rewrite README.md for trainee

**Files:**
- Modify: `<root>/README.md`

- [ ] **Step 1: Replace README contents**

Overwrite `<root>/README.md` with:

````markdown
# FC Quiz App — Trainee Project

A simple quiz app you'll build during your week at FC-Gruppe.
The trivia questions come from the free [Open Trivia DB](https://opentdb.com/).

## Run it

```bash
flutter pub get
flutter run
```

Make sure an Android emulator is running (Pixel 7 API 34).

## Project layout

```
lib/
  main.dart              # app entry
  models/                # plain data classes
  services/              # talks to the API
  screens/               # full pages (home, quiz, result)
  widgets/               # small reusable UI pieces
mockups/                 # design references (PNGs)
```

## Your tasks

Search the code for `TODO(trainee)` — those are the spots you fill in.

1. **`models/question.dart`** — write `Question.fromJson(Map<String, dynamic>)`
2. **`services/trivia_api.dart`** — call the API, return a list of `Question`
3. **`screens/home_screen.dart`** — wire the **Start** button to fetch questions and push the quiz screen
4. **`screens/quiz_screen.dart`** — track current question index + score, handle answer taps, push result screen when done
5. **`screens/result_screen.dart`** — wire **Restart** to pop back to home
6. **Styling pass** — restyle every screen to match the Figma mockups in `mockups/`

## API cheat sheet

- Endpoint: `https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple`
- Response: `{ response_code, results: [{ question, correct_answer, incorrect_answers, ... }] }`
- Question text uses HTML entities (`&quot;`, `&#039;`). Decode with the `html_unescape` package.
- Categories list: `https://opentdb.com/api_category.php`

## Bonus (only if you finish early)

- Save high score with `shared_preferences`
- Add a difficulty selector to the home screen
- Animate transitions between questions
````

- [ ] **Step 2: Commit**

```bash
cd <root>
git add README.md
git commit -m "docs: rewrite README for trainee"
```

---

### Task 3: Update main.dart

**Files:**
- Modify: `<root>/lib/main.dart`

- [ ] **Step 1: Replace main.dart contents**

Overwrite `<root>/lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const FcQuizApp());
}

class FcQuizApp extends StatelessWidget {
  const FcQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FC Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
```

> **Note:** `HomeScreen` does not exist yet — this file will not compile until Task 8. That is expected. We commit it anyway because subsequent tasks depend on this entry point existing.

- [ ] **Step 2: Commit**

```bash
cd <root>
git add lib/main.dart
git commit -m "feat: add MaterialApp shell pointing at HomeScreen"
```

---

### Task 4: Create Question model (with TODO factory)

**Files:**
- Create: `<root>/lib/models/question.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/models/question.dart`:

```dart
/// One quiz question fetched from Open Trivia DB.
class Question {
  final String text;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String category;
  final String difficulty;

  const Question({
    required this.text,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.category,
    required this.difficulty,
  });

  /// All four answers, shuffled, ready to display as buttons.
  List<String> get shuffledAnswers {
    final all = [...incorrectAnswers, correctAnswer];
    all.shuffle();
    return all;
  }

  // TODO(trainee): build a Question from the JSON the API returns.
  //
  // The API returns a Map that looks like:
  // {
  //   "question": "What is ...?",
  //   "correct_answer": "Paris",
  //   "incorrect_answers": ["London", "Berlin", "Madrid"],
  //   "category": "Geography",
  //   "difficulty": "easy",
  //   "type": "multiple"
  // }
  //
  // Tip: Map<String, dynamic> json
  // Tip: incorrect_answers is a List<dynamic> — cast each item to String.
  // Tip: Don't worry about HTML entities yet — that's handled in trivia_api.dart.
  factory Question.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TODO(trainee): implement Question.fromJson');
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze lib/models/question.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/models/question.dart
git commit -m "feat: add Question model with TODO fromJson factory"
```

---

### Task 5: Create QuizResult model

**Files:**
- Create: `<root>/lib/models/quiz_result.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/models/quiz_result.dart`:

```dart
/// Final outcome of one quiz run.
class QuizResult {
  final int score;
  final int total;
  final DateTime finishedAt;

  const QuizResult({
    required this.score,
    required this.total,
    required this.finishedAt,
  });

  /// Score as a percentage between 0 and 100.
  double get percentage => total == 0 ? 0 : (score / total) * 100;

  /// Friendly message based on percentage.
  String get summary {
    if (percentage >= 80) return 'Great job!';
    if (percentage >= 50) return 'Not bad — try again!';
    return 'Keep practicing!';
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze lib/models/quiz_result.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/models/quiz_result.dart
git commit -m "feat: add QuizResult model"
```

---

### Task 6: Create trivia_api.dart stub

**Files:**
- Create: `<root>/lib/services/trivia_api.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/services/trivia_api.dart`:

```dart
import 'package:fc_learning_app/models/question.dart';

/// Client for the Open Trivia DB.
///
/// API docs: https://opentdb.com/api_config.php
class TriviaApi {
  static const String _base = 'https://opentdb.com/api.php';

  // TODO(trainee): implement fetchQuestions.
  //
  // Steps:
  //  1. Build the URL with the given params, e.g.
  //     https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple
  //  2. Use the `http` package: http.get(Uri.parse(url))
  //  3. Check response.statusCode == 200, throw otherwise
  //  4. jsonDecode the body — it's a Map<String, dynamic>
  //  5. The "results" key holds a List of question maps
  //  6. For each map: Question.fromJson(map)
  //  7. Decode HTML entities in question + answer text using the
  //     `html_unescape` package (HtmlUnescape().convert(...))
  //
  // Imports you'll likely need:
  //   import 'dart:convert';
  //   import 'package:http/http.dart' as http;
  //   import 'package:html_unescape/html_unescape.dart';
  Future<List<Question>> fetchQuestions({
    int amount = 10,
    int category = 18, // 18 = Computers
    String difficulty = 'easy',
  }) async {
    throw UnimplementedError('TODO(trainee): implement fetchQuestions');
  }
}
```

> **Note:** the `import 'package:fc_learning_app/...'` line must use the actual package name from `pubspec.yaml`. If `flutter create` produced a different name, substitute it. (Same applies in every file from here on.)

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze lib/services/trivia_api.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/services/trivia_api.dart
git commit -m "feat: add TriviaApi stub with TODO fetchQuestions"
```

---

### Task 7a: Create AnswerButton widget

**Files:**
- Create: `<root>/lib/widgets/answer_button.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/widgets/answer_button.dart`:

```dart
import 'package:flutter/material.dart';

/// One tappable answer on the quiz screen.
class AnswerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze lib/widgets/answer_button.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/widgets/answer_button.dart
git commit -m "feat: add AnswerButton widget"
```

---

### Task 7b: Create QuestionCard widget

**Files:**
- Create: `<root>/lib/widgets/question_card.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/widgets/question_card.dart`:

```dart
import 'package:flutter/material.dart';

/// Card that displays the current question text.
class QuestionCard extends StatelessWidget {
  final String text;

  const QuestionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze lib/widgets/question_card.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/widgets/question_card.dart
git commit -m "feat: add QuestionCard widget"
```

---

### Task 8: Create HomeScreen (basic UI, TODO wiring)

**Files:**
- Create: `<root>/lib/screens/home_screen.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Open Trivia DB category id. 9 = General Knowledge, 18 = Computers, etc.
  int _selectedCategory = 9;

  static const List<DropdownMenuItem<int>> _categories = [
    DropdownMenuItem(value: 9, child: Text('General Knowledge')),
    DropdownMenuItem(value: 18, child: Text('Computers')),
    DropdownMenuItem(value: 23, child: Text('History')),
    DropdownMenuItem(value: 21, child: Text('Sports')),
  ];

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
            DropdownButtonFormField<int>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onStartPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _onStartPressed() {
    // TODO(trainee): wire the start button.
    //
    // Steps:
    //  1. Create a TriviaApi() instance.
    //  2. Call fetchQuestions(category: _selectedCategory).
    //  3. While loading, show a CircularProgressIndicator (hint: a bool field
    //     `_loading` plus setState).
    //  4. On success, Navigator.push to QuizScreen with the questions list.
    //  5. On error, show a SnackBar with the error message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Start button')),
    );
  }
}
```

- [ ] **Step 2: Verify app compiles**

Run: `cd <root> && flutter analyze`
Expected: `No issues found!` (main.dart now resolves HomeScreen.)

- [ ] **Step 3: Smoke-test on emulator**

Run: `cd <root> && flutter run -d emulator-5554` (or whatever Android emulator id is showing in `flutter devices`).
Expected: app launches, shows "FC Quiz" title, category dropdown, and Start button. Tapping Start shows the TODO snackbar.

- [ ] **Step 4: Commit**

```bash
cd <root>
git add lib/screens/home_screen.dart
git commit -m "feat: add HomeScreen with TODO start wiring"
```

---

### Task 9: Create QuizScreen (basic UI, TODO state)

**Files:**
- Create: `<root>/lib/screens/quiz_screen.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/screens/quiz_screen.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/question.dart';
import 'package:fc_learning_app/widgets/answer_button.dart';
import 'package:fc_learning_app/widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // TODO(trainee): track quiz progress.
  //
  // You will need at least:
  //   int _currentIndex = 0;
  //   int _score = 0;
  //
  // When the user taps an answer:
  //  1. Compare the tapped label with question.correctAnswer.
  //  2. If correct, increment _score.
  //  3. If there are more questions, increment _currentIndex with setState.
  //  4. Otherwise, build a QuizResult and Navigator.pushReplacement to ResultScreen.

  @override
  Widget build(BuildContext context) {
    // Static placeholder so the screen renders even before the trainee
    // implements the state logic. They will replace this with the real one.
    final placeholder = widget.questions.isNotEmpty
        ? widget.questions.first
        : const Question(
            text: 'Placeholder question — implement state logic to see real ones.',
            correctAnswer: 'A',
            incorrectAnswers: ['B', 'C', 'D'],
            category: 'Demo',
            difficulty: 'easy',
          );
    final answers = placeholder.shuffledAnswers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '0 / ${widget.questions.length}', // TODO(trainee): real index
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            QuestionCard(text: placeholder.text),
            const SizedBox(height: 24),
            for (final answer in answers)
              AnswerButton(
                label: answer,
                onTap: () => _onAnswerTap(answer, placeholder.correctAnswer),
              ),
          ],
        ),
      ),
    );
  }

  void _onAnswerTap(String tapped, String correct) {
    // TODO(trainee): replace this stub with real progression logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tapped == correct ? 'Correct!' : 'Wrong — was $correct'),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/screens/quiz_screen.dart
git commit -m "feat: add QuizScreen with TODO state logic"
```

---

### Task 10: Create ResultScreen (basic UI, TODO restart)

**Files:**
- Create: `<root>/lib/screens/result_screen.dart`

- [ ] **Step 1: Create the file**

Write `<root>/lib/screens/result_screen.dart`:

```dart
import 'package:flutter/material.dart';

import 'package:fc_learning_app/models/quiz_result.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, size: 96),
            const SizedBox(height: 24),
            Text(
              '${result.score} / ${result.total}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              result.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => _onRestartPressed(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Restart', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _onRestartPressed(BuildContext context) {
    // TODO(trainee): pop back to HomeScreen.
    //
    // Hint: Navigator.popUntil(context, (route) => route.isFirst)
    // sends the user back to the very first screen in the stack.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO(trainee): wire Restart button')),
    );
  }
}
```

- [ ] **Step 2: Verify analyzer passes**

Run: `cd <root> && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd <root>
git add lib/screens/result_screen.dart
git commit -m "feat: add ResultScreen with TODO restart wiring"
```

---

### Task 11: Add mockups placeholder

**Files:**
- Create: `<root>/mockups/README.md`

- [ ] **Step 1: Create the directory and README**

Run: `mkdir -p <root>/mockups`

Write `<root>/mockups/README.md`:

```markdown
# Mockups

Drop the Figma exports here:

- `home.png` — home screen
- `quiz.png` — quiz screen
- `result.png` — result screen
- `style-guide.png` — colors, fonts, spacing

Reference these from each screen during the styling pass.
```

- [ ] **Step 2: Commit**

```bash
cd <root>
git add mockups/README.md
git commit -m "chore: add mockups folder placeholder"
```

---

### Task 12: Final scaffold sanity check + push

**Files:** none (validation only)

- [ ] **Step 1: Run analyzer across the whole project**

Run: `cd <root> && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 2: Run the app on the emulator end-to-end**

Run: `cd <root> && flutter run -d emulator-5554`
Expected:
- App launches on Home screen.
- Tapping **Start** → TODO snackbar (no crash).
- Manually navigate to QuizScreen via `flutter run` hot-reload tweak (not required — trainee will wire it).

- [ ] **Step 3: Push main**

```bash
cd <root>
git push -u origin main
```

Expected: branch `main` exists on remote with all scaffold commits.

- [ ] **Step 4: Verify on remote**

Run: `cd <root> && git log --oneline -20`
Expected: linear history of `chore/feat/docs` commits from Tasks 1–11.

---

## Phase 2 — Bug-Hunt Branches (Tasks 13–16)

These branches require a complete, working implementation as their base — otherwise there is nothing for a "planted bug" to break. We build that base on a private branch `bug-base`, then fork each bug branch off it.

### Task 13: Create bug-base branch with full reference implementation

**Files (all on branch `bug-base`):**
- Modify: `<root>/lib/models/question.dart`
- Modify: `<root>/lib/services/trivia_api.dart`
- Modify: `<root>/lib/screens/home_screen.dart`
- Modify: `<root>/lib/screens/quiz_screen.dart`
- Modify: `<root>/lib/screens/result_screen.dart`

- [ ] **Step 1: Branch off main**

```bash
cd <root>
git checkout main
git checkout -b bug-base
```

- [ ] **Step 2: Implement Question.fromJson**

Replace the body of the `Question.fromJson` factory in `<root>/lib/models/question.dart` (keep the rest of the file unchanged):

```dart
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      incorrectAnswers: (json['incorrect_answers'] as List)
          .map((e) => e as String)
          .toList(),
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
    );
  }
```

Also delete the long `// TODO(trainee): ...` comment block above the factory.

- [ ] **Step 3: Implement TriviaApi.fetchQuestions**

Replace the entire contents of `<root>/lib/services/trivia_api.dart` with:

```dart
import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import 'package:fc_learning_app/models/question.dart';

class TriviaApi {
  static const String _base = 'https://opentdb.com/api.php';
  final HtmlUnescape _unescape = HtmlUnescape();

  Future<List<Question>> fetchQuestions({
    int amount = 10,
    int category = 18,
    String difficulty = 'easy',
  }) async {
    final uri = Uri.parse(
      '$_base?amount=$amount&category=$category&difficulty=$difficulty&type=multiple',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Trivia API failed: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List;
    return results.map((raw) {
      final map = raw as Map<String, dynamic>;
      return Question(
        text: _unescape.convert(map['question'] as String),
        correctAnswer: _unescape.convert(map['correct_answer'] as String),
        incorrectAnswers: (map['incorrect_answers'] as List)
            .map((e) => _unescape.convert(e as String))
            .toList(),
        category: map['category'] as String,
        difficulty: map['difficulty'] as String,
      );
    }).toList();
  }
}
```

- [ ] **Step 4: Wire HomeScreen Start button**

In `<root>/lib/screens/home_screen.dart`:

(a) Add a new field at the top of `_HomeScreenState`, right below `int _selectedCategory = 9;`:

```dart
  bool _loading = false;
```

(b) Replace the `_onStartPressed` method with:

```dart
  Future<void> _onStartPressed() async {
    setState(() => _loading = true);
    try {
      final api = TriviaApi();
      final questions =
          await api.fetchQuestions(category: _selectedCategory);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(questions: questions),
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
```

Add the matching imports at the top of the file:

```dart
import 'package:fc_learning_app/screens/quiz_screen.dart';
import 'package:fc_learning_app/services/trivia_api.dart';
```

Replace the `Start` button child to reflect loading state — change the `child:` of the bottom `ElevatedButton` to:

```dart
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Start', style: TextStyle(fontSize: 18)),
```

- [ ] **Step 5: Wire QuizScreen state logic**

Replace the entire body of `_QuizScreenState` in `<root>/lib/screens/quiz_screen.dart` with:

```dart
class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
    _answers = widget.questions[_currentIndex].shuffledAnswers;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${widget.questions.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            QuestionCard(text: question.text),
            const SizedBox(height: 24),
            for (final answer in _answers)
              AnswerButton(
                label: answer,
                onTap: () => _onAnswerTap(answer, question.correctAnswer),
              ),
          ],
        ),
      ),
    );
  }

  void _onAnswerTap(String tapped, String correct) {
    if (tapped == correct) _score++;
    if (_currentIndex + 1 < widget.questions.length) {
      setState(() {
        _currentIndex++;
        _answers = widget.questions[_currentIndex].shuffledAnswers;
      });
    } else {
      final result = QuizResult(
        score: _score,
        total: widget.questions.length,
        finishedAt: DateTime.now(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      );
    }
  }
}
```

Add imports:

```dart
import 'package:fc_learning_app/models/quiz_result.dart';
import 'package:fc_learning_app/screens/result_screen.dart';
```

- [ ] **Step 6: Wire ResultScreen Restart**

In `<root>/lib/screens/result_screen.dart`, replace the `_onRestartPressed` method with:

```dart
  void _onRestartPressed(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
```

- [ ] **Step 7: Smoke-test full flow**

Run: `cd <root> && flutter analyze && flutter run -d emulator-5554`
Expected:
- Pick a category → Start → 10 questions appear.
- Tapping answers progresses; counter updates `1 / 10` → `10 / 10`.
- Final answer → Result screen with score.
- Restart → back to Home.

- [ ] **Step 8: Commit and push bug-base**

```bash
cd <root>
git add lib/
git commit -m "feat(bug-base): full reference implementation for bug branches"
git push -u origin bug-base
```

---

### Task 14: Create bug/easy — off-by-one in question counter

**Files (on branch `bug/easy`):**
- Modify: `<root>/lib/screens/quiz_screen.dart`

- [ ] **Step 1: Branch off bug-base**

```bash
cd <root>
git checkout bug-base
git checkout -b bug/easy
```

- [ ] **Step 2: Plant the bug**

In `<root>/lib/screens/quiz_screen.dart`, change the counter line in the `AppBar` actions from:

```dart
                '${_currentIndex + 1} / ${widget.questions.length}',
```

to:

```dart
                '$_currentIndex / ${widget.questions.length}', // bug: starts at 0
```

(Remove the comment before pushing — see Step 4.)

- [ ] **Step 3: Verify the bug visibly**

Run: `cd <root> && flutter run -d emulator-5554`
Expected: when the quiz starts, the top counter shows `0 / 10` instead of `1 / 10`. This is the symptom the trainee should spot.

- [ ] **Step 4: Strip the giveaway comment**

Remove the `// bug: starts at 0` comment so the trainee has to actually find it.

- [ ] **Step 5: Commit and push**

```bash
cd <root>
git add lib/screens/quiz_screen.dart
git commit -m "bug(easy): off-by-one in question counter"
git push -u origin bug/easy
```

---

### Task 15: Create bug/medium — score not reset on restart

**Files (on branch `bug/medium`):**
- Modify: `<root>/lib/screens/quiz_screen.dart`

- [ ] **Step 1: Branch off bug-base (NOT bug/easy)**

```bash
cd <root>
git checkout bug-base
git checkout -b bug/medium
```

- [ ] **Step 2: Plant the bug**

The existing reference impl already returns to Home cleanly via `Navigator.popUntil`. The bug we want is: **`_score` from the previous run leaks into the next run**. To make that observable we need to keep the `_QuizScreenState` alive across restarts.

In `<root>/lib/screens/quiz_screen.dart`, change `int _score = 0;` (declared at the top of `_QuizScreenState`) to a static field so it survives across `QuizScreen` instances:

```dart
  int _currentIndex = 0;
  static int _score = 0; // bug: static — leaks across restarts
```

(Remove the `// bug: ...` comment before pushing — Step 4.)

- [ ] **Step 3: Verify the bug visibly**

Run: `cd <root> && flutter run -d emulator-5554`
Expected:
- Run 1: answer 3 of 10 correctly → result `3/10`. Tap Restart.
- Run 2: answer 0 of 10 correctly → result `3/10` (should be `0/10`).

- [ ] **Step 4: Strip the giveaway comment**

Remove the `// bug: static — leaks across restarts` comment.

- [ ] **Step 5: Commit and push**

```bash
cd <root>
git add lib/screens/quiz_screen.dart
git commit -m "bug(medium): score not reset on restart"
git push -u origin bug/medium
```

---

### Task 16 (optional): Create bug/hard — async race in API call

**Files (on branch `bug/hard`):**
- Modify: `<root>/lib/screens/home_screen.dart`

- [ ] **Step 1: Branch off bug-base**

```bash
cd <root>
git checkout bug-base
git checkout -b bug/hard
```

- [ ] **Step 2: Plant the bug**

In `<root>/lib/screens/home_screen.dart`, modify `_onStartPressed` so it does NOT guard against double-taps and does NOT cancel a stale request. Then weaken the `mounted` check before navigation. Replace `_onStartPressed` with:

```dart
  Future<void> _onStartPressed() async {
    setState(() => _loading = true);
    final api = TriviaApi();
    // bug: no guard against double-tap; first response wins, second navigates
    // on top, leaving an orphan loading state on the previous push.
    final questions = await api.fetchQuestions(category: _selectedCategory);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizScreen(questions: questions)),
    );
    setState(() => _loading = false);
  }
```

(Remove the `// bug: ...` comment before pushing — Step 4.)

- [ ] **Step 3: Verify the bug visibly**

Run: `cd <root> && flutter run -d emulator-5554`
Expected: rapid double-tap on Start → two QuizScreens get pushed in succession; back-button navigates through stale screens. Also, if the user navigates away mid-fetch, you get a `setState() called after dispose` warning in the console.

- [ ] **Step 4: Strip the giveaway comment**

Remove the `// bug: ...` comment.

- [ ] **Step 5: Commit and push**

```bash
cd <root>
git add lib/screens/home_screen.dart
git commit -m "bug(hard): async race in start button"
git push -u origin bug/hard
```

---

### Task 17: Cleanup — return to main

**Files:** none (git only)

- [ ] **Step 1: Switch back to main**

```bash
cd <root>
git checkout main
git status
```

Expected: `On branch main`, working tree clean.

- [ ] **Step 2: List all branches**

Run: `cd <root> && git branch -a`
Expected (at minimum):
```
* main
  bug-base
  bug/easy
  bug/medium
  bug/hard           # only if Task 16 done
  remotes/origin/main
  remotes/origin/bug-base
  remotes/origin/bug/easy
  remotes/origin/bug/medium
  remotes/origin/bug/hard
```

- [ ] **Step 3: Done — handover note**

Scaffold lives on `main`. Trainee gets pushed to it on Day 2. Bug-hunt exercise on Day 4 uses `git checkout bug/easy` (then `bug/medium`, optionally `bug/hard`). `bug-base` stays private from the trainee — do not mention it during the week.

---

## Out of scope (deferred)

- iOS-specific signing, icons, splash screen
- Localization (English only by design)
- Tests (unit, widget, integration) — deliberate omission for trainee focus
- Solution branch with full reference (the trainee finishes this themselves; `bug-base` is the closest equivalent and stays private)
- Figma mockups — provided externally, dropped into `mockups/` later
- `shared_preferences` high score, difficulty selector, transition animations — listed as bonus tasks in the README

## Risks

- **Open Trivia DB rate-limits / outage on Day 4.** Mitigation: the API stub already throws cleanly; trainee sees the SnackBar. Backup plan: switch to a JSON fixture loaded from `assets/`.
- **`flutter create` produced a different package name than `fc_learning_app`.** Mitigation: every import path in this plan flagged at Task 6; substitute the real name globally before Task 8 (the first file with cross-imports).
- **Trainee laptop emulator does not boot.** Mitigation: scaffold runs on web (`flutter run -d chrome`) too — verify on web during Task 12 as a fallback signal.
