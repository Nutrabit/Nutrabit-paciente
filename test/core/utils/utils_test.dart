import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart'; // ajustá la ruta según tu proyecto
import 'package:intl/intl.dart';

void main() {
  group('normalize', () {
    test('remueve acentos y convierte a minúsculas', () {
      expect(normalize('Árbol Ñandú Café'), 'arbol nandu cafe');
    });
  });

  group('isValidEmail', () {
    test('emails válidos', () {
      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('user.name123@domain.io'), isTrue);
    });

    test('emails inválidos', () {
      expect(isValidEmail('test@.com'), isFalse);
      expect(isValidEmail('test@domain'), isFalse);
      expect(isValidEmail('testdomain.com'), isFalse);
    });
  });

  group('calculateAge', () {
    test('calcula edad correctamente si ya cumplió años', () {
      final birthday = DateTime(DateTime.now().year - 30, 1, 1);
      expect(calculateAge(birthday), 30);
    });

    test('calcula edad correctamente si aún no cumplió años', () {
      final birthday = DateTime(DateTime.now().year - 30, DateTime.now().month + 1, 1);
      expect(calculateAge(birthday), 29);
    });
  });

  group('capitalize', () {
    test('capitaliza la primera letra', () {
      expect('flutter'.capitalize(), 'Flutter');
    });

    test('devuelve string vacío si está vacío', () {
      expect(''.capitalize(), '');
    });
  });

  group('formatDate', () {
    test('devuelve string formateado dd/MM/yyyy HH:mm', () {
      final date = DateTime(2023, 5, 10, 14, 30);
      expect(formatDate(date), DateFormat('dd/MM/yyyy HH:mm').format(date));
    });
  });

  group('generateRandomPassword', () {
    test('genera contraseña de longitud especificada', () {
      final password = generateRandomPassword(length: 8);
      expect(password.length, 8);
    });

    test('genera contraseñas aleatorias', () {
      final p1 = generateRandomPassword();
      final p2 = generateRandomPassword();
      expect(p1 == p2, isFalse); // poco probable que coincidan
    });
  });

  testWidgets('showCustomDialog displays message and dismisses on button press', (WidgetTester tester) async {
    // Montamos una app mínima para tener contexto
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      message: 'Mensaje de prueba',
                      buttonText: 'Cerrar',
                      buttonColor: Colors.blue,
                    );
                  },
                  child: Text('Mostrar diálogo'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Tap al botón que muestra el diálogo
    await tester.tap(find.text('Mostrar diálogo'));
    await tester.pumpAndSettle(); // Esperar a que se muestre el diálogo

    // Verificamos que aparezca el mensaje y el botón
    expect(find.text('Mensaje de prueba'), findsOneWidget);
    expect(find.text('Cerrar'), findsOneWidget);

    // Tap al botón del diálogo para cerrarlo
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();

    // Verificamos que el diálogo haya desaparecido
    expect(find.text('Mensaje de prueba'), findsNothing);
  });
}
