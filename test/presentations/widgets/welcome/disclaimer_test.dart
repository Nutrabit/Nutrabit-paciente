import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/widgets/welcome/disclaimer.dart';

void main() {
  testWidgets('Disclaimer widget basic UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Disclaimer(),
      ),
    );

    // Verificar que el texto "¡Atención!" esté presente
    final titleFinder = find.text('¡Atención!');
    expect(titleFinder, findsOneWidget);

    // Verificar que el texto descriptivo esté presente (puede buscar parte del texto)
    final descriptionFinder = find.textContaining('Esta app no busca reemplazar');
    expect(descriptionFinder, findsOneWidget);

    // Verificar que la imagen esté presente con el asset correcto
    final imageFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/img/nutriaAbrazo.png',
    );
    expect(imageFinder, findsOneWidget);

    // Opcional: Verificar color de fondo del Scaffold
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(220, 96, 122, 1));
  });
}
