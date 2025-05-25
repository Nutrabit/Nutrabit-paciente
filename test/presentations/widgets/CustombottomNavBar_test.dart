import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/widgets/CustombottomNavBar.dart';


void main() {
testWidgets('CustomBottomAppBar icons respond to taps', (WidgetTester tester) async {
  int selectedIndex = 0;
  final icons = [Icons.home, Icons.notifications, Icons.person];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CustomBottomAppBar(
          currentIndex: selectedIndex,
          onItemSelected: (index) {
            selectedIndex = index;
          },
          icons: icons,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
      ),
    ),
  );

  // Verificar que todos los íconos están presentes
  for (final icon in icons) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  // Simular tap en el segundo icono
  await tester.tap(find.byIcon(Icons.notifications));
  expect(selectedIndex, 1);

  // Simular tap en el tercer icono
  await tester.tap(find.byIcon(Icons.person));
  expect(selectedIndex, 2);
});
}
