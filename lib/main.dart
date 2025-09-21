// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/template_browse_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/template_preview_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Video Editor',
      
      // --- MODIFIED SECTION START ---
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // A deep gray
        primaryColor: Colors.blueAccent,
        // Define a color scheme for consistent component colors
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.blueAccent,
          surface: Color(0xFF2A2A2A), // Slightly lighter gray for cards/panels
          background: Color(0xFF1E1E1E),
        ),
        // Style the app bar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A),
          elevation: 1,
        ),
        // Style floating action buttons, elevated buttons etc.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // --- MODIFIED SECTION END ---

      home: const HomeScreen(),
      routes: {
        '/browse': (context) => const TemplateBrowseScreen(),
        '/create': (context) => const EditorScreen(),
        // Keep the preview screen route, we may use it later
        '/template-preview': (context) => const TemplatePreviewScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}