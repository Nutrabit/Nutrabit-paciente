import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../auxfiles/patient_detail_aux.dart';

void main() {
  testWidgets('PatientInfoCard shows patient data correctly', (WidgetTester tester) async {
    bool editTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PatientInfoCard(
              name: 'Juan Pérez',
              email: 'juan@example.com',
              age: '30',
              weight: '70',
              height: '175',
              diet: 'Sin sal',
              profilePic: null,
              onEdit: () {
                editTapped = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('juan@example.com'), findsOneWidget);
    expect(find.text('Edad: 30'), findsOneWidget);
    expect(find.text('70 kg / 175 cm'), findsOneWidget);
    expect(find.text('Sin sal'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    expect(editTapped, isTrue);
  });

}
