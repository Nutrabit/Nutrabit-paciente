import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nutrabit_paciente/presentations/screens/files/detalleArchivo.dart';
import 'package:nutrabit_paciente/presentations/screens/login.dart';
import 'package:nutrabit_paciente/core/router/app-router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Navegar a /login muestra Login widget', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );

    appRouter.go('/login');
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets('Navegar a ruta con parámetro muestra widget con parámetro', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );

    appRouter.go('/archivos/123');
    await tester.pumpAndSettle();

    expect(find.byType(DetalleArchivo), findsOneWidget);
  });

}
