import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/screens/amIPatient.dart';

void main() {
  Widget createTestableWidget() {
    final router = GoRouter(
      initialLocation: '/start',
      routes: [
        GoRoute(
          path: '/start',
          builder: (context, state) => const AmIPatient(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Pantalla Login')),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Pantalla Home')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('Muestra botones y navega correctamente', (tester) async {
    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    // Verifica los textos de los botones
    expect(find.text('Soy paciente'), findsOneWidget);
    expect(find.text('No soy paciente'), findsOneWidget);

    // Toca "Soy paciente" y verifica navegación a /login
    await tester.tap(find.text('Soy paciente'));
    await tester.pumpAndSettle();
    expect(find.text('Pantalla Login'), findsOneWidget);

    // Vuelve al inicio para el siguiente test
    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    // Toca "No soy paciente" y verifica navegación a /
    await tester.tap(find.text('No soy paciente'));
    await tester.pumpAndSettle();
    expect(find.text('Pantalla Home'), findsOneWidget);
  });
}
