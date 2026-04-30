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
}
