import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'package:nested_nav/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('herrega/progress'), (call) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('herrega/progress'), null);
  });
  testWidgets('app opens the maths learning path and an interactive lesson',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Herrega'), findsOneWidget);
    expect(find.byKey(const ValueKey('recommended-start')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('recommended-start')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('line-right')), findsOneWidget);
    expect(find.byKey(const ValueKey('definition-card')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
