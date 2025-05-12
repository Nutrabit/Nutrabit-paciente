enum FileType {
  SHOPPING_LIST,
  EXERCISE_PLAN,
  MEAL_PLAN,
  RECOMMENDATIONS
}

extension FileTypeExtension on FileType {
  String get description {
    switch (this) {
      case FileType.SHOPPING_LIST:
        return "Lista de Compras";
      case FileType.EXERCISE_PLAN:
        return "Plan de Ejercicio";
      case FileType.MEAL_PLAN:
        return "Plan de Alimentación";
      case FileType.RECOMMENDATIONS:
        return "Recomendaciones";
    }
  }
}