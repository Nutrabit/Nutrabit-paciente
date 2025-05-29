import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';

class NewEventDialog {
  static void show(
    BuildContext context, {
    DateTime? initialDate,
    EventType? initialType,
  }) {
    final EventService _eventService = EventService();
    EventType? selectedEventType = initialType ?? EventType.DRINK_WATER;
    DateTime? selectedDate = initialDate ?? DateTime.now();
    if (initialType == EventType.APPOINTMENT && initialDate == null) {
      selectedDate = DateTime.now().copyWith(hour: 9, minute: 0);
    }
    final TextEditingController descriptionController = TextEditingController();
    const excludedTypes = {
      EventType.UPLOAD_FILE,
      EventType.PERIOD,
      EventType.APPOINTMENT,
    };

    Future<void> uploadAndSaveEvent() async {
      if (selectedEventType == EventType.UPLOAD_FILE) {
        context.push('/envios', extra: selectedDate);
      } else {
        if (selectedEventType != null) {
          await _eventService.uploadEvent(
            fileBytes: Uint8List(0),
            fileName: '',
            title: selectedEventType!.description,
            description:
                selectedEventType != EventType.APPOINTMENT
                    ? descriptionController.text
                    : '${selectedDate!.hour}:${selectedDate!.minute} hs',
            type: selectedEventType!.name,
            dateTime: selectedDate!,
          );
        }
      }
    }

    Future<void> pickTime() async {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && selectedDate != null) {
        selectedDate = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          time.hour,
          time.minute,
        );
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
                      title: Text(
                        'Fecha: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      ),
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
                    ...EventType.values.expand((eventType) {
                      final isSelected = selectedEventType == eventType;
                      return [
                        RadioListTile<EventType>(
                          title: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(220, 96, 122, 0.4),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: eventType.icon,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(eventType.pluralDescription),
                              ),
                            ],
                          ),
                          value: eventType,
                          groupValue: selectedEventType,
                          onChanged: (value) {
                            setState(() {
                              selectedEventType = value;
                            });
                          },
                        ),
                        if (isSelected && !excludedTypes.contains(eventType))
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Descripción',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        if (isSelected && eventType == EventType.APPOINTMENT)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: InkWell(
                              onTap: () async {
                                await pickTime();
                                setState(
                                  () {},
                                ); // Esto es clave para que se vea el cambio
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Hora',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? TimeOfDay.fromDateTime(
                                        selectedDate!,
                                      ).format(context)
                                      : 'Seleccionar hora',
                                ),
                              ),
                            ),
                          ),
                      ];
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Aceptar'),
                  style: mainButtonDecoration(),
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
