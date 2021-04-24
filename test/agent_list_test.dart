// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_admin_2021/ui/agent_list.dart';
import 'package:money_library_2021/widgets/round_number.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
  });

  group('MoneyPlatform Widget Tests 3 🍐 🍐 🍐', () {
    testWidgets('AgentList widget exists', (WidgetTester tester) async {
      var agentList = AgentList();
      await tester.pumpWidget(MaterialApp(
        home: SafeArea(child: agentList),
      ));
      // Tap the add button.
      var finder = find.byWidget(agentList);
      expect(finder, findsOneWidget);
      var buttons = find.byType(IconButton);
      print('🍐🍐🍐  AgentList iconButtons; there should be 3 iconButtons');
      print(buttons);
      expect(buttons.evaluate().length, 3);

      var numWidget = find.byType(RoundNumberWidget);
      print('🍐🍐🍐  numWidget; there should be 1');
      expect(numWidget, findsOneWidget);

      print(
          '🍐🍐🍐 found AgentList OK 🍎 and checked that I have the required widgets 🍐🍐🍐');
    });
  });
}
