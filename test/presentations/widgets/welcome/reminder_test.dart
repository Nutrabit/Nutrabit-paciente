import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/presentations/screens/welcome/reminder.dart';

void main() {
  testWidgets('Reminder widget basic UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Reminder(),
      ),
    );

    // Verificar el texto principal
    expect(find.text('¡Importante recordar!'), findsOneWidget);

    // Verificar un texto descriptivo
    expect(find.textContaining('La salud es multifactorial'), findsOneWidget);

    // Verificar la primera imagen (rectangleGreen.png)
    final image1Finder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/img/rectangleGreen.png',
    );
    expect(image1Finder, findsOneWidget);

    // Verificar la segunda imagen (meditation.png)
    final image2Finder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/img/meditation.png',
    );
    expect(image2Finder, findsOneWidget);

    // Verificar el color de fondo del Scaffold
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(255, 255, 255, 1));
  });
}
