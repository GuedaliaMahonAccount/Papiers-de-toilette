import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EndlessPaperRollApp());
}

class EndlessPaperRollApp extends StatelessWidget {
  const EndlessPaperRollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endless Paper Roll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5F5F0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
