import 'package:flutter/material.dart';

import 'package:fc_learning_app/theme/app_theme.dart';
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
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
