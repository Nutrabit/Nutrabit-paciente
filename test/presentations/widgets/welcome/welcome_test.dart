import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/presentations/screens/welcome/welcome.dart';

void main() {
  testWidgets('Welcome widget basic UI test', (WidgetTester tester) async {
    // Probar con un tamaño arbitrario para MediaQuery
    const screenHeight = 800.0;
    const screenWidth = 400.0;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(screenWidth, screenHeight),
          ),
          child: const Welcome(),
        ),
      ),
    );

    // Verificar los textos
    expect(find.text('¡Bienvenido'), findsOneWidget);
    expect(find.text('a tu nuevo estilo de vida!'), findsOneWidget);

    // Verificar color de fondo del Scaffold
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(253, 238, 219, 1));

    // Verificar que haya un SizedBox con altura aproximada al 35% del alto de pantalla
    final sizedBoxFinder = find.byWidgetPredicate((widget) {
      return widget is SizedBox &&
          (widget.height != null && (widget.height! - screenHeight * 0.35).abs() < 1);
    });
    expect(sizedBoxFinder, findsWidgets); // Puede haber más de uno

  });
}
