import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum EventType {
  DRINK_WATER,
  EXERCISE,
  SUPLEMENT,
  PERIOD,
  UPLOAD_FILE,
  APPOINTMENT
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
      case EventType.UPLOAD_FILE:
        return "Archivo";
      case EventType.APPOINTMENT:
        return "Tengo un turno asignado";
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
      case EventType.UPLOAD_FILE:
        return "Subir archivos";
      case EventType.PERIOD:
        return "¿Tienes tu período?";
      case EventType.APPOINTMENT:
        return "Tengo un turno asignado";
    }
  }

  FaIcon get icon {
    switch (this) {
      case EventType.DRINK_WATER:
        return FaIcon(FontAwesomeIcons.glassWaterDroplet);
      case EventType.EXERCISE:
        return FaIcon(FontAwesomeIcons.personRunning);
      case EventType.SUPLEMENT:
        return FaIcon(FontAwesomeIcons.capsules);
      case EventType.UPLOAD_FILE:
        return FaIcon(FontAwesomeIcons.fileArrowUp);
      case EventType.PERIOD:
        return FaIcon(FontAwesomeIcons.droplet);
      case EventType.APPOINTMENT:
        return FaIcon(FontAwesomeIcons.calendarDay);
    }
  }

    IconData get iconData {
    switch (this) {
      case EventType.DRINK_WATER:
        return FontAwesomeIcons.glassWaterDroplet;
      case EventType.EXERCISE:
        return FontAwesomeIcons.personRunning;
      case EventType.SUPLEMENT:
        return FontAwesomeIcons.capsules;
      case EventType.PERIOD:
        return FontAwesomeIcons.droplet;
      case EventType.UPLOAD_FILE:
        return FontAwesomeIcons.fileArrowUp;
      case EventType.APPOINTMENT:
        return FontAwesomeIcons.calendarDay;
    }
  }

    Color get iconColor {
    switch (this) {
      case EventType.DRINK_WATER:
        return Color(0xFF01C7F4);
      case EventType.EXERCISE:
        return Color(0xFF9DF726);
      case EventType.SUPLEMENT:
        return Color(0xFFF49F0A);
      case EventType.PERIOD:
        return Color(0xFFFF230A);
      case EventType.UPLOAD_FILE:
        return Color(0xFFf8e61b);
      case EventType.APPOINTMENT:
        return Color(0xFFEAC5EF);
    }
  }
}