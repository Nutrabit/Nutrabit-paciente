import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/widgets/CustombottomNavBar.dart';

void main() {
  testWidgets('CustomBottomAppBar onItemSelected callback test by icon', (WidgetTester tester) async {
    int selectedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomAppBar(
            currentIndex: 0,
            onItemSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      ),
    );

    // Buscamos el icono de perfil (suponiendo que usas Icons.person)
    final profileIconFinder = find.byIcon(Icons.person);
    expect(profileIconFinder, findsOneWidget);

    await tester.tap(profileIconFinder);
    await tester.pumpAndSettle();

    // Asumiendo que el botón perfil corresponde al índice 2
    expect(selectedIndex, 2);
  });

testWidgets('CustomBottomAppBar calls onItemSelected with index 0 when Home icon tapped', (WidgetTester tester) async {
  int selectedIndex = -1;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CustomBottomAppBar(
          currentIndex: 2,
          onItemSelected: (index) {
            selectedIndex = index;
          },
        ),
      ),
    ),
  );

  final homeIconFinder = find.byIcon(Icons.home);
  expect(homeIconFinder, findsOneWidget);

  await tester.tap(homeIconFinder);
  await tester.pumpAndSettle();

  expect(selectedIndex, 0);
});

}
