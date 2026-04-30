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
