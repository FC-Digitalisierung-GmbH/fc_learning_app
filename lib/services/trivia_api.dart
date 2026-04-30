import 'package:fc_learning_app/models/question.dart';

/// Client for the Open Trivia DB.
///
/// API docs: https://opentdb.com/api_config.php
class TriviaApi {
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
