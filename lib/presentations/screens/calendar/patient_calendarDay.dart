import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/newEventDialog.dart';

class CalendarDayPatient extends ConsumerWidget {
  final DateTime date;
  final EventService _eventService = EventService();
  CalendarDayPatient({required this.date, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fomatedDate = DateFormat('dd/MM/yyyy').format(date);
    final asyncEventsByDate = ref.watch(eventsByDateProvider);
    final keyDate = DateTime(date.year, date.month, date.day);

    Future<void> deleteEvent(String eventId) async {
      return await _eventService.deleteEvent(eventId);
    }

    Widget _getEventTypeIcon(
      String typeName, {
      double size = 10.0,
      Color color = const Color(0xFFDC607A),
    }) {
      try {
        final type = EventType.values.firstWhere((t) => t.name == typeName);
        return FaIcon(type.iconData, size: size, color: type.iconColor);
      } catch (e) {
        return FaIcon(
          FontAwesomeIcons.circleQuestion,
          size: size,
          color: color,
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4E9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4E9F7),
        title: const Text(
          "Detalle",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFF4E9F7),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Text(
              fomatedDate,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC607A),
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Eventos del día",
                        style: TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: asyncEventsByDate.when(
                      data: (eventsMap) {
                        final dayEvents = eventsMap.entries
                        .where((entry) =>
                          entry.key.year == keyDate.year &&
                          entry.key.month == keyDate.month &&
                          entry.key.day == keyDate.day,
                        )
                        .expand((entry) => entry.value)
                        .toList();

                        if (dayEvents.isEmpty) {
                          return const Center(
                            child: Text("No hay eventos para este día."),
                          );
                        }

                        return ListView.builder(
                          itemCount: dayEvents.length,
                          itemBuilder: (context, index) {
                            final _event = dayEvents[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *0.03),
                                          child: _getEventTypeIcon(
                                            _event.type,
                                            size: 20,
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              _event.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            var showDialog2 = showDialog<bool>(
                                              context: context,
                                              builder:
                                                  (_) => DeleteAlertDialog()
                                            );
                                            final confirm = await showDialog2;
                                            if (confirm == true) {
                                              await deleteEvent(_event.id);
                                            }
                                          },
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        if (_event.file.isNotEmpty &&
                                            _event.type == 'UPLOAD_FILE')
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              _event.file,
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              fit: BoxFit.contain,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => const Icon(
                                                Icons.broken_image,
                                                size: 100,
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(height: 13),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _event.description,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text("Error al cargar _events: $error")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {NewEventDialog.show(context, initialDate: DateTime.utc(
                  keyDate.year,
                  keyDate.month,
                  keyDate.day,
                  3));},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar evento'),
      content: const Text('¿Estás seguro de que deseas eliminar el evento del calendario?'),
      actions: [
        TextButton(
          onPressed:() => Navigator.pop(context,false),
          child: const Text('Cancelar')
        ),
        TextButton(
          onPressed:() => Navigator.pop(context,true),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}