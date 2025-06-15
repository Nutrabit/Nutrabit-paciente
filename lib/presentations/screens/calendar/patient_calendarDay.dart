import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/notification_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/newEventDialog.dart';

class CalendarDayPatient extends ConsumerWidget {
  final DateTime date;
  final EventService _eventService = EventService();
  final notificationService = NotificationService();
  CalendarDayPatient({required this.date, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final asyncEventsByDate = ref.watch(eventsByDateProvider);
    final keyDate = DateTime(date.year, date.month, date.day);
    final user = ref.watch(authProvider).value;

    Future<void> deleteEvent(dynamic event) async {
      await _eventService.deleteEvent(event.id.toString());
      if(event.type == EventType.APPOINTMENT.name){
        await notificationService.deleteNotificationsByTopicAndTime(topic: user!.id, scheduledTime: event.date.subtract(Duration(hours: 24)));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4E9F7),
      appBar: _CalendarAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarHeader(date: formattedDate),
          Expanded(
            child: _EventsContainer(
              keyDate: keyDate,
              asyncEventsByDate: asyncEventsByDate,
              getIcon: _getEventTypeIcon,
              deleteEvent: deleteEvent,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NewEventDialog.show(
          context,
          initialDate: DateTime.utc(keyDate.year, keyDate.month, keyDate.day, 3),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
    );
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
      return FaIcon(FontAwesomeIcons.circleQuestion, size: size, color: color);
    }
  }
}

class _CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4E9F7),
      title: const Text("Detalle", style: TextStyle(color: Colors.black)),
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CalendarHeader extends StatelessWidget {
  final String date;

  const _CalendarHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4E9F7),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFDC607A),
        ),
      ),
    );
  }
}

class _EventsContainer extends StatelessWidget {
  final DateTime keyDate;
  final AsyncValue<Map<DateTime, List<dynamic>>> asyncEventsByDate;
  final Widget Function(String, {double size, Color color}) getIcon;
  final Future<void> Function(dynamic) deleteEvent;

  const _EventsContainer({
    required this.keyDate,
    required this.asyncEventsByDate,
    required this.getIcon,
    required this.deleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text("Eventos del día", style: TextStyle(fontSize: 17)),
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
                        entry.key.day == keyDate.day)
                    .expand((entry) => entry.value)
                    .toList();

                if (dayEvents.isEmpty) {
                  return const Center(child: Text("No hay eventos para este día."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return _EventCard(
                      event: event,
                      getIcon: getIcon,
                      deleteEvent: deleteEvent,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text("Error al cargar eventos: $error")),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final dynamic event;
  final Widget Function(String, {double size, Color color}) getIcon;
  final Future<void> Function(dynamic) deleteEvent;

  const _EventCard({
    required this.event,
    required this.getIcon,
    required this.deleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: getIcon(event.type, size: 20),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      event.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = showDialog(
                      context: context,
                      builder: (context) => DeleteAlertDialog(style: defaultAlertDialogStyle),
                    );
                    if (confirm == true) await deleteEvent(event);
                  },
                ),
              ],
            ),
            if (event.file.isNotEmpty && event.type == 'UPLOAD_FILE')
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  event.file,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                ),
              )
            else
              const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: Text(event.description, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAlertDialog extends StatelessWidget {
  final AlertDialogStyle style;

  const DeleteAlertDialog({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: style.backgroundColor,
      elevation: style.elevation,
      shape: style.shape,
      titleTextStyle: style.titleTextStyle,
      contentTextStyle: style.contentTextStyle,
      title: const Text('Eliminar evento'),
      content: const Text('¿Estás seguro de que deseas eliminar el evento del calendario?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: style.buttonStyle,
          child: Text('Eliminar', style: style.buttonTextStyle),
        ),
      ],
    );
  }
}


