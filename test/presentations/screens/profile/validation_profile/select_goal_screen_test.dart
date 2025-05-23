import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrabit_paciente/presentations/providers/user_provider.dart';
import '../../../../auxfiles/select_goal_screen_aux.dart';

// Mock de UserNotifier
class MockUserNotifier extends Mock implements UserNotifier {}

void main() {
  late MockUserNotifier mockUserNotifier;

  setUp(() {
    mockUserNotifier = MockUserNotifier();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
  overrides: [
    userProvider.overrideWith((ref) => mockUserNotifier),
  ],
  child: const MaterialApp(
    home: SelectGoalScreen(),
  ),
);
  }

  testWidgets('Muestra los goals y permite seleccionar uno', (tester) async {
    // Al llamar updateFields no hacemos nada (simulamos éxito)
    when(() => mockUserNotifier.updateFields(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    // Verificamos que los goals estén en pantalla
    expect(find.text('Perder grasa'), findsOneWidget);
    expect(find.text('Mantener peso'), findsOneWidget);
    expect(find.text('Aumentar peso'), findsOneWidget);
    expect(find.text('Ganar músculo'), findsOneWidget);
    expect(find.text('Crear hábitos saludables'), findsOneWidget);

    // Tocar un goal
    await tester.tap(find.text('Perder grasa'));
    await tester.pumpAndSettle();

    // Verificamos que updateFields fue llamado con el valor correcto
    verify(() => mockUserNotifier.updateFields({'goal': 'Perder grasa'})).called(1);
  });

  testWidgets('Muestra snackbar en caso de error al guardar goal', (tester) async {
    // Simular error al actualizar
    when(() => mockUserNotifier.updateFields(any())).thenThrow(Exception('fallo'));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Ganar músculo'));
    await tester.pump(); // para mostrar snackbar

    expect(find.textContaining('Error al guardar'), findsOneWidget);
  });

  testWidgets('StepIndicator muestra paso activo correctamente', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StepIndicator(currentStep: 1, totalSteps: 2),
        ),
      ),
    );

    // Busca los dos indicadores (containers con ancho 40 y alto 6)
    final indicators = find.byType(AnimatedContainer);
    expect(indicators, findsNWidgets(2));

    // Verifica color del paso activo (index 1) y el inactivo (index 0)
    final animatedContainers = tester.widgetList<AnimatedContainer>(indicators).toList();

    final activeDecoration = animatedContainers[1].decoration as BoxDecoration;
    final inactiveDecoration = animatedContainers[0].decoration as BoxDecoration;

    expect(activeDecoration.color, const Color(0xFFD87B91));
    expect(inactiveDecoration.color, const Color(0xFFE0E0E0));
  });

  testWidgets('GoalCard muestra icono de imagen rota si no encuentra la imagen', (tester) async {
    // Imagen con ruta inválida para forzar error
    const goalWithBrokenImage = {
      'label': 'Objetivo roto',
      'image': 'assets/img/imagen_invalida.png',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(
            goal: goalWithBrokenImage,
            onTap: () {},
          ),
        ),
      ),
    );

    // Espera a que la imagen intente cargar y falle
    await tester.pumpAndSettle();

    // Verifica que el icono de imagen rota aparece
    expect(find.byIcon(Icons.broken_image), findsOneWidget);

    // Verifica que el texto del label aparece
    expect(find.text('Objetivo roto'), findsOneWidget);
  });
  testWidgets('GoalCard ejecuta onTap cuando se toca', (tester) async {
    bool tapped = false;

    const goal = {
      'label': 'Test Goal',
      'image': 'assets/img/perder_grasa.png',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(
            goal: goal,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Verifica que inicialmente tapped es false
    expect(tapped, isFalse);

    // Toca la GoalCard
    await tester.tap(find.byType(GoalCard));
    await tester.pump();

    // Ahora tapped debe ser true
    expect(tapped, isTrue);
  });
}
