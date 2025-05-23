import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/password/change_password.dart';

// Mock de AuthNotifier
class MockAuthNotifier extends Mock implements AuthNotifier {}

void main() {
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockAuthNotifier = MockAuthNotifier();

    // Cuando se llama updatePassword, devuelve un Future<void>
    when(() => mockAuthNotifier.updatePassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
      repeatPassword: any(named: 'repeatPassword'),
    )).thenAnswer((_) => Future.value());

    // Cuando se lee el estado actual del notifier, retorna AsyncData(null) (o puedes retornar un AppUser mock)
    when(() => mockAuthNotifier.build()).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        // override correcto, retorna la instancia mock (el notifier)
        authProvider.overrideWithProvider(
          AsyncNotifierProvider<AuthNotifier, AppUser?>(
            () => mockAuthNotifier,
          ),
        ),
      ],
      child: const MaterialApp(home: ChangePassword()),
    );
  }

  testWidgets('renders all text fields and button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.widgetWithText(TextField, 'Contraseña actual'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nueva contraseña'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Repetir contraseña'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Aceptar'), findsOneWidget);
  });

  testWidgets('shows snackbar if fields are empty and button tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Por favor, complete todos los campos.'), findsOneWidget);
  });

}
