// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('English Learning App loads successfully', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EnglishLearningApp());

    // Let the splash screen animation complete
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the splash screen loads
    expect(find.text('English Master'), findsOneWidget);
    expect(find.text('Learn English the fun way'), findsOneWidget);

    // Clean up pending timers
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
