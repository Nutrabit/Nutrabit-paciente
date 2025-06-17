import 'package:flutter/material.dart';
enum FileType {
  SHOPPING_LIST,
  EXTRA_INFORMATION,
  MEAL_PLAN,
  RECOMMENDATIONS,
  MEASUREMENTS
}

extension FileTypeExtension on FileType {
  String get description {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return "Lista de compras";
      case FileType.EXTRA_INFORMATION:
        return "Información extra";
      case FileType.MEAL_PLAN:
        return "Plan de alimentación";
      case FileType.RECOMMENDATIONS:
        return "Recomendaciones";
      case FileType.MEASUREMENTS:
          return "Mediciones";
    }
  }

  String get pluralDescription {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return "Listas de compra";
      case FileType.EXTRA_INFORMATION:
        return "Información extra";
      case FileType.MEAL_PLAN:
        return "Planes de alimentación";
      case FileType.RECOMMENDATIONS:
        return "Recomendaciones";
      case FileType.MEASUREMENTS:
        return "Mediciones";
    }
  }

  IconData get icon {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return Icons.shopping_cart;
      case FileType.EXTRA_INFORMATION:
        return Icons.fitness_center;
      case FileType.MEAL_PLAN:
        return Icons.restaurant_menu;
      case FileType.RECOMMENDATIONS:
        return Icons.thumb_up;
      case FileType.MEASUREMENTS:
        return Icons.straighten;
    }
  }
}