import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../../../auxfiles/profile_dynamic_screen_aux.dart'; 

void main() {
  testWidgets('GenderDropdown shows options and validates properly', (WidgetTester tester) async {
    String? selectedValue;

    // Construimos el widget dentro de un MaterialApp para que funcione el Dropdown
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GenderDropdown(
            value: null,
            onChanged: (v) => selectedValue = v,
          ),
        ),
      ),
    );

    // Verificar que el texto por defecto no está seleccionado (el valor es null)
    expect(find.text('Masculino'), findsNothing);
    expect(find.text('Femenino'), findsNothing);
    expect(find.text('Otro'), findsNothing);

    // Abrir el dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Ahora las opciones deben estar visibles
    expect(find.text('Masculino'), findsOneWidget);
    expect(find.text('Femenino'), findsOneWidget);
    expect(find.text('Otro'), findsOneWidget);

    // Prueba de validación: sin seleccionar nada, el validator debe devolver error
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: GenderDropdown(
              value: null,
              onChanged: (v) {},
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState?.validate(), isFalse);
  });

  testWidgets('BirthdayPicker shows date and calls onDateSelected on tap', (WidgetTester tester) async {
    DateTime? selectedDate;

    // Fecha que va a devolver nuestro "picker mock"
    final mockSelectedDate = DateTime(1990, 5, 20);

    // Función mock que simula el showDatePicker y devuelve una fecha fija
    Future<DateTime?> mockDatePicker(BuildContext context, DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
      return mockSelectedDate;
    }

    // Construimos el widget con fecha nula
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirthdayPicker(
            date: null,
            onDateSelected: (date) => selectedDate = date,
            datePickerBuilder: mockDatePicker,
          ),
        ),
      ),
    );

    // Debe mostrar el texto por defecto
    expect(find.text('Selecciona una fecha'), findsOneWidget);

    // Tap para abrir el picker (mockeado)
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // El callback debe haberse llamado con la fecha mockeada
    expect(selectedDate, mockSelectedDate);

    // Ahora construimos con una fecha inicial para que se muestre formateada
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BirthdayPicker(
            date: mockSelectedDate,
            onDateSelected: (date) {},
            datePickerBuilder: mockDatePicker,
          ),
        ),
      ),
    );

    final formattedDate = DateFormat.yMMMd().format(mockSelectedDate);

    expect(find.text(formattedDate), findsOneWidget);
  });

  testWidgets('HeightWeightFields validation and input', (WidgetTester tester) async {
    final heightController = TextEditingController();
    final weightController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: HeightWeightFields(
              heightController: heightController,
              weightController: weightController,
            ),
          ),
        ),
      ),
    );

    // Inicialmente vacíos, la validación debe fallar
    expect(formKey.currentState?.validate(), isFalse);

    // Escribimos un valor inválido (letra) en altura y peso
    await tester.enterText(find.widgetWithText(TextFormField, 'cm'), 'abc');
    await tester.enterText(find.widgetWithText(TextFormField, 'kg'), 'xyz');

    // Disparamos la validación
    expect(formKey.currentState?.validate(), isFalse);

    // Ahora valores inválidos numéricos (0 o negativos)
    await tester.enterText(find.widgetWithText(TextFormField, 'cm'), '0');
    await tester.enterText(find.widgetWithText(TextFormField, 'kg'), '-5');
    expect(formKey.currentState?.validate(), isFalse);

    // Finalmente valores válidos
    await tester.enterText(find.widgetWithText(TextFormField, 'cm'), '175');
    await tester.enterText(find.widgetWithText(TextFormField, 'kg'), '70');

    // Al hacer validate() debe devolver true
    expect(formKey.currentState?.validate(), isTrue);

    // También podemos verificar que los controladores contienen lo que escribimos
    expect(heightController.text, '175');
    expect(weightController.text, '70');

    heightController.dispose();
    weightController.dispose();
  });

  testWidgets('StepIndicator shows correct number of steps and active step color', (WidgetTester tester) async {
    // Paso activo 0, total 3
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StepIndicator(totalSteps: 3, currentStep: 0),
        ),
      ),
    );

    // Debe encontrar 3 indicadores
    final indicators = find.byType(AnimatedContainer);
    expect(indicators, findsNWidgets(3));

    // El primer indicador debe tener el color activo (0xFFD87B91)
    final firstBox = tester.widget<AnimatedContainer>(indicators.first);
    final firstBoxDecoration = firstBox.decoration as BoxDecoration;
    expect(firstBoxDecoration.color, const Color(0xFFD87B91));

    // Los otros deben tener color inactivo (0xFFE0E0E0)
    for (final i in [1, 2]) {
      final box = tester.widget<AnimatedContainer>(indicators.at(i));
      final boxDecoration = box.decoration as BoxDecoration;
      expect(boxDecoration.color, const Color(0xFFE0E0E0));
    }

    // Ahora probamos con currentStep = 2
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StepIndicator(totalSteps: 3, currentStep: 2),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final newIndicators = find.byType(AnimatedContainer);
    expect(newIndicators, findsNWidgets(3));

    // El tercer indicador debe ser activo
    final thirdBox = tester.widget<AnimatedContainer>(newIndicators.at(2));
    final thirdBoxDecoration = thirdBox.decoration as BoxDecoration;
    expect(thirdBoxDecoration.color, const Color(0xFFD87B91));
  });
}