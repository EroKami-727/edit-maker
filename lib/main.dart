// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/template_browse_screen.dart';
import 'screens/editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Video Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // You can change this
      ),
      home: const HomeScreen(),
      routes: {
        '/browse': (context) => const TemplateBrowseScreen(),
        '/create': (context) => const EditorScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}