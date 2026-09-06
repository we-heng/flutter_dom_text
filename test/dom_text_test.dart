import 'package:dom_text/dom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DomText falls back to Flutter Text off web', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DomText('Hello DOM'))),
    );

    expect(find.text('Hello DOM'), findsOneWidget);
  });

  testWidgets('DomText can be used as a button label', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () => pressed = true,
            child: const DomText(
              'Press me',
              cursorEvent: false,
              softWrap: false,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(pressed, isTrue);
  });
}
