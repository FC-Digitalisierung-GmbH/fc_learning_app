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
