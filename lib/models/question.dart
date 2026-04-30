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
