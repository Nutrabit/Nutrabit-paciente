import 'package:flutter/material.dart';
enum FileType {
  SHOPPING_LIST,
  EXERCISE_PLAN,
  MEAL_PLAN,
  RECOMMENDATIONS,
}

extension FileTypeExtension on FileType {
  String get description {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return "Lista de compras";
      case FileType.EXERCISE_PLAN:
        return "Plan de ejercicio";
      case FileType.MEAL_PLAN:
        return "Plan de alimentación";
      case FileType.RECOMMENDATIONS:
        return "Recomendaciones";
    }
  }

  String get pluralDescription {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return "Listas de compra";
      case FileType.EXERCISE_PLAN:
        return "Planes de ejercicio";
      case FileType.MEAL_PLAN:
        return "Planes de alimentación";
      case FileType.RECOMMENDATIONS:
        return "Recomendaciones";
    }
  }

  IconData get icon {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return Icons.shopping_cart;
      case FileType.EXERCISE_PLAN:
        return Icons.fitness_center;
      case FileType.MEAL_PLAN:
        return Icons.restaurant_menu;
      case FileType.RECOMMENDATIONS:
        return Icons.thumb_up;
    }
  }
}