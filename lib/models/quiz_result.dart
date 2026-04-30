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
