import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';


import '../../../auxfiles/patient_modifier_aux.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    // Crear instancia limpia de Firestore falso antes de cada test
    fakeFirestore = FakeFirebaseFirestore();
  });

  testWidgets('Muestra loading inicialmente', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        // PASA la instancia fakeFirestore al widget si es posible
        home: PatientModifier(id: 'test_user', firestore: fakeFirestore),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Formulario se muestra con datos y permite editar campos', (WidgetTester tester) async {
    // Preparar datos en Firestore falso para simular que ya hay datos
    await fakeFirestore.collection('users').doc('test_user').set({
      'height': 170,
      'weight': 65,
      'gender': 'Masculino',
      'profilePic': '',
    });

    await tester.pumpWidget(
      MaterialApp(home: PatientModifier(id: 'test_user', firestore: fakeFirestore)),
    );

    final state = tester.state(find.byType(PatientModifier)) as PatientModifierState;

    await tester.pumpAndSettle();

    // Ya no debe mostrar loading
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Los campos deben tener los valores iniciales
    expect(find.widgetWithText(TextField, '170'), findsOneWidget);
    expect(find.widgetWithText(TextField, '65'), findsOneWidget);

    // Cambiar altura
    await tester.enterText(find.byType(TextField).at(0), '180');
    expect(find.widgetWithText(TextField, '180'), findsOneWidget);

    // Cambiar peso
    await tester.enterText(find.byType(TextField).at(1), '70');
    expect(find.widgetWithText(TextField, '70'), findsOneWidget);

    // Cambiar dropdown de género
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Femenino').last);
    await tester.pumpAndSettle();
    expect(state.selectedGender, 'Femenino');

    expect(find.text('Guardar cambios'), findsOneWidget);
  });
}
