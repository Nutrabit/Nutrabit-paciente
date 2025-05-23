import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:nutrabit_paciente/core/models/file_type.dart'; // Ajustá el path según tu proyecto

void main() {
  group('FileTypeExtension', () {
    test('description returns correct string', () {
      expect(FileType.SHOPPING_LIST.description, 'Lista de compras');
      expect(FileType.EXERCISE_PLAN.description, 'Plan de ejercicio');
      expect(FileType.MEAL_PLAN.description, 'Plan de alimentación');
      expect(FileType.RECOMMENDATIONS.description, 'Recomendaciones');
      expect(FileType.BASURA.description, 'Basura');
    });

    test('pluralDescription returns correct string', () {
      expect(FileType.SHOPPING_LIST.pluralDescription, 'Listas de compra');
      expect(FileType.EXERCISE_PLAN.pluralDescription, 'Planes de ejercicio');
      expect(FileType.MEAL_PLAN.pluralDescription, 'Planes de alimentación');
      expect(FileType.RECOMMENDATIONS.pluralDescription, 'Recomendaciones');
      expect(FileType.BASURA.pluralDescription, 'Basura');
    });

    test('icon returns correct IconData', () {
      expect(FileType.SHOPPING_LIST.icon, Icons.shopping_cart);
      expect(FileType.EXERCISE_PLAN.icon, Icons.fitness_center);
      expect(FileType.MEAL_PLAN.icon, Icons.restaurant_menu);
      expect(FileType.RECOMMENDATIONS.icon, Icons.thumb_up);
      expect(FileType.BASURA.icon, Icons.delete);
    });
  });
}