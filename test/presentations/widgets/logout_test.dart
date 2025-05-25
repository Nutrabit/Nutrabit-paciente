import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/widgets/logout.dart';

void main() {
  testWidgets('Logout button shows confirmation dialog', (WidgetTester tester) async {
    // Renderiza el widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Logout(),
        ),
      ),
    );

    // Busca el IconButton y lo toca
    expect(find.byType(IconButton), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // Verifica que aparece el diálogo con los textos esperados
    expect(find.text('¿Cerrar sesión?'), findsOneWidget);
    expect(find.text('¿Estás segura/o de que querés cerrar sesión?'), findsOneWidget);

    // Verifica que aparecen los botones Cancelar y Cerrar sesión
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Cerrar sesión'), findsOneWidget);
  });
}
