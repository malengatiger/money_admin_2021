// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:introduction_screen/src/ui/intro_button.dart';
import 'package:money_admin_2021/ui/intro/intro_mobile.dart';

void main() {
  group('MoneyPlatform Widget Tests', () {
    testWidgets('IntroMobile widget exists', (WidgetTester tester) async {
      // Build the widget.
      var intro = IntroMobile();
      await tester.pumpWidget(MaterialApp(
        home: SafeArea(child: intro),
      ));
      // Tap the add button.
      var finder = find.byWidget(intro);
      expect(finder, findsOneWidget);
      var buttons = find.byType(IntroButton);
      print('👽👽👽👽👽👽👽👽 buttons');
      print(buttons);
      await tester.tap(buttons.first);
      await tester.pump();
      await tester.tap(buttons.last);
      await tester.pump();
      print(
          '🔵 🔵 🔵 👽👽👽👽 found and tapped the next and done buttons on IntroMobile');
    });
  });
}
