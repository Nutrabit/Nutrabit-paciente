import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Botón muestra texto y responde al tap', (WidgetTester tester) async {
  bool pressed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {
            pressed = true;
          },
          child: Text('Test Button'),
        ),
      ),
    ),
  );

  expect(find.text('Test Button'), findsOneWidget);

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  expect(pressed, isTrue);
});


}
