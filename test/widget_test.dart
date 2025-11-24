// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vector/main.dart';

void main() {
  testWidgets('Vector app smoke test', (WidgetTester tester) async {
    // Set a larger screen size for the test
    await tester.binding.setSurfaceSize(const Size(400, 800));

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VectorApp()));
    await tester.pumpAndSettle();

    // Verify that the landing screen shows up
    expect(find.text('Vector'), findsOneWidget);
    expect(find.text('Money in Motion'), findsOneWidget);
    expect(find.text('Pay Someone'), findsOneWidget);
    expect(find.text('Get Paid'), findsOneWidget);
  });
}
