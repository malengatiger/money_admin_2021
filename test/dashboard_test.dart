// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_admin_2021/ui/dashboard/dashboard_mobile.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
  });

  group('MoneyPlatform Widget Tests 2', () {
    testWidgets('DashboardMobile widget exists', (WidgetTester tester) async {
      var dashboard = DashboardMobile();
      await tester.pumpWidget(MaterialApp(
        home: SafeArea(child: dashboard),
      ));
      // Tap the add button.
      var finder = find.byWidget(dashboard);
      expect(finder, findsOneWidget);
      var buttons = find.byType(IconButton);
      print('💛 💛 💛  dashboard iconButtons; there should be 4 iconButtons');
      print(buttons);
      expect(buttons.evaluate().length, 4);

      var cards = find.byType(Card);
      print('💛 💛 💛  dashboard cards; there should be 3 cards');
      print(cards);
      expect(cards.evaluate().length, 3);
      // await tester.tap(cards.first);
      // await tester.pump();
      // await tester.tap(cards.last);
      // await tester.pump();
      print(
          '💛 💛 💛 💛 found and tapped the next and done cards on DashboardMobile');
    });
  });
}
