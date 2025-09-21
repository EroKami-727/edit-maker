import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Video Editor'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Template Video Editor!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create amazing video templates',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to template browser
              },
              child: const Text('Browse Templates'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to template creator
              },
              child: const Text('Create Template'),
            ),
          ],
        ),
      ),
    );
  }
}