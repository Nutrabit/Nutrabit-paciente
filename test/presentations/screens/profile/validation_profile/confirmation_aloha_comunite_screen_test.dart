import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/confirmation_aloha_comunite_screen.dart';


void main() {
  testWidgets('ConfirmationScreen shows image and navigates after delay', (tester) async {
    // Creamos un GoRouter con dos rutas: confirmation y home
    final router = GoRouter(
      initialLocation: '/confirmation',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Home Screen'))),
        ),
        GoRoute(
          path: '/confirmation',
          builder: (context, state) => const ConfirmationScreen(),
        ),
      ],
    );

    // Inyectamos el router en MaterialApp.router
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    // Verificamos que la pantalla de confirmation está presente (la imagen)
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Center), findsWidgets);

    // Avanzamos el tiempo 2 segundos + un poco más para asegurar que Future.delayed se ejecute
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Después de 2 segundos debería navegar a la ruta '/'
    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.byType(ConfirmationScreen), findsNothing);
  });
}
