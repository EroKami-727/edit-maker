import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app loads with the welcome text
    expect(find.text('Welcome to Edit Maker!'), findsOneWidget);
    expect(find.text('Browse Templates'), findsOneWidget);
    expect(find.text('Create Template'), findsOneWidget);
  });
}