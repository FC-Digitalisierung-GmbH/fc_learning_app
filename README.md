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
