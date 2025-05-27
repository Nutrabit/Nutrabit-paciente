import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';

class NewEventDialog {
  static void show(BuildContext context, {DateTime? initialDate}) {
    final EventService _eventService = EventService();
    DateTime? selectedDate = initialDate ?? DateTime.now();
    EventType? selectedEventType;

    Future<void> uploadAndSaveEvent() async {
      if (selectedEventType == EventType.UPLOAD_FILE) {
        context.push('/envios', extra: selectedDate);
      } else {
        if (selectedEventType != null) {

          await _eventService.uploadEvent(
            fileBytes: Uint8List(0),
            fileName: '',
            title: selectedEventType!.description,
            description: '',
            type: selectedEventType!.name,
            dateTime: selectedDate!,
          );
        }
        ;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Seleccionar evento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Fecha: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2055),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    Divider(),
                    ...EventType.values.map((eventType) {
                      return RadioListTile<EventType>(
                        title: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(220, 96, 122, 0.4), // Fondo del icono
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: eventType.icon,
                            ),
                            // eventType.icon,
                            SizedBox(width: 5),
                            Expanded(child: Text(eventType.pluralDescription)),
                          ],
                        ),
                        value: eventType,
                        groupValue: selectedEventType,
                        onChanged: (value) {
                          setState(() {
                            selectedEventType = value;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    uploadAndSaveEvent();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
