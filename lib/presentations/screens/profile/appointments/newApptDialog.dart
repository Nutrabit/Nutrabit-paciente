import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/models/notification_model.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';
import 'package:nutrabit_paciente/presentations/providers/notification_provider.dart';

class NewApptDialog {
  static void show(BuildContext context, {DateTime? initialDate}) {
    final EventService _eventService = EventService();
    DateTime selectedDate = initialDate ?? DateTime.now();

    Future<void> uploadAndSaveEvent() async {
      await _eventService.uploadEvent(
        fileBytes: Uint8List(0),
        fileName: '',
        title: EventType.APPOINTMENT.description,
        description: '${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')} hs',
        type: EventType.APPOINTMENT.name,
        dateTime: selectedDate,
      );
      await _createNotification(selectedDate);
    }

    Future<void> pickTime() async {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
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
              title: Text('Seleccionar turno'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      'Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2055),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            selectedDate.hour,
                            selectedDate.minute,
                          );
                        });
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      await pickTime();
                      setState(() {});
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        TimeOfDay.fromDateTime(selectedDate).format(context),
                      ),
                    ),
                  ),
                ],
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

Future<void> _createNotification(DateTime apptTime) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final oneDayBefore = apptTime.subtract(Duration(hours: 24));
  final oneMinBefore = apptTime.subtract(Duration(minutes: 1));
  final model = NotificationModel(
    id: '',
    title: 'Turno con la Lic. Florencia Cabral',
    topic: _auth.currentUser!.uid,
    description: "${apptTime.day.toString().padLeft(2, '0')}-${apptTime.month.toString().padLeft(2, '0')} a las ${apptTime.hour.toString().padLeft(2, '0')}:${apptTime.minute.toString().padLeft(2, '0')} hs",
    scheduledTime: oneDayBefore,
    endDate: oneMinBefore,
    repeatEvery: 1,
    urlIcon: '',
    cancel: false,
  );

  final notificationService = NotificationService();

  try {
    await notificationService.createNotification(model);
  } catch (e) {
    print(e);
  };
}
