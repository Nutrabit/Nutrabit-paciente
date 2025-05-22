import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum EventType {
  DRINK_WATER,
  EXERCISE,
  SUPLEMENT,
  PERIOD,
  FOOD_PICTURE,
}

extension EventTypeExtension on EventType {
  String get description {
    switch (this) {
      case EventType.DRINK_WATER:
        return "Tomé agua";
      case EventType.EXERCISE:
        return "Hice ejercicio";
      case EventType.SUPLEMENT:
        return "Tomé un suplemento";
      case EventType.PERIOD:
        return "Tengo mi período";
      case EventType.FOOD_PICTURE:
        return "Fotos de comida";
    }
  }

  String get pluralDescription {
    switch (this) {
      case EventType.DRINK_WATER:
        return "¿Bebiste agua?";
      case EventType.EXERCISE:
        return "¿Hiciste ejercicio?";
      case EventType.SUPLEMENT:
        return "¿Tomaste suplemento?";
      case EventType.PERIOD:
        return "¿Tienes tu período?";
      case EventType.FOOD_PICTURE:
        return "Subir fotos de comida";
    }
  }

  FaIcon get icon {
    switch (this) {
      case EventType.DRINK_WATER:
        return FaIcon(FontAwesomeIcons.glassWaterDroplet);
      case EventType.EXERCISE:
        return FaIcon(FontAwesomeIcons.personRunning);
      case EventType.SUPLEMENT:
        return FaIcon(FontAwesomeIcons.pills);
      case EventType.PERIOD:
        return FaIcon(FontAwesomeIcons.droplet);
      case EventType.FOOD_PICTURE:
        return FaIcon(FontAwesomeIcons.appleWhole);
    }
  }
}