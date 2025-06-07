final assetsPath = 'assets/img';

enum GoalModel {
  PERDER_GRASA,
  MANTENER_PESO,
  AUMENTAR_PESO,
  GANAR_MUSCULO,
  HABITOS_SALUDABLES
}

extension GoalModelExtension on GoalModel {
  String get description {
    switch (this) {
      case GoalModel.PERDER_GRASA:
        return "Perder grasa";
      case GoalModel.MANTENER_PESO:
        return "Mantener peso";
      case GoalModel.AUMENTAR_PESO:
        return "Aumentar peso";
      case GoalModel.GANAR_MUSCULO:
        return "Ganar músculo";
      case GoalModel.HABITOS_SALUDABLES:
          return "Crear hábitos saludables";
    }
  }

  String get imageUrl {
    switch (this) {
      case GoalModel.PERDER_GRASA:
        return "$assetsPath/perder_grasa.png";
      case GoalModel.MANTENER_PESO:
        return "$assetsPath/mantener_peso.png";
      case GoalModel.AUMENTAR_PESO:
        return "$assetsPath/aumentar_peso.png";
      case GoalModel.GANAR_MUSCULO:
        return "$assetsPath/ganar_musculo.png";
      case GoalModel.HABITOS_SALUDABLES:
          return "$assetsPath/habitos.png";
    }
  }
}