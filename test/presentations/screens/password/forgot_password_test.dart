import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/password/forgot_password.dart';
import 'forgot_password_test.mocks.dart'; 

@GenerateMocks([AuthNotifier])
void main() {
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockAuthNotifier = MockAuthNotifier();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [authProvider.overrideWith(() => mockAuthNotifier)],
      child: const MaterialApp(home: ForgotPassword()),
    );
  }

  testWidgets('Muestra snackbar al ingresar email inválido', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final button = find.text('Enviar email de recuperación');
    await tester.tap(button);
    await tester.pump();

    expect(find.text('Ingrese un email válido.'), findsOneWidget);
  });

}

