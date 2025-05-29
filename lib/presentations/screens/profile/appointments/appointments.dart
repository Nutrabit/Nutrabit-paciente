import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';
import 'package:intl/intl.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/newEventDialog.dart';

class Appointments extends ConsumerWidget {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(eventsStreamProvider);
    final appUser = ref.watch(authProvider);

    if (appUser is AsyncLoading || allEvents is AsyncLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return allEvents.when(
      data: (events) {
        final appointmentEvents =
            events.where((e) => e.type == EventType.APPOINTMENT.name).toList();
        final nextAppointment =
            appointmentEvents
                .where((e) => e.date.isAfter(DateTime.now().toLocal()))
                .toList();
        final previousAppointments =
            appointmentEvents
                .where((e) => e.date.isBefore(DateTime.now().toLocal()))
                .toList();
        previousAppointments.sort((a, b) => b.date.compareTo(a.date));

        
        return Scaffold(
          backgroundColor: Color.fromRGBO(253, 238, 219, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(253, 238, 219, 1),

            leading: BackButton(
              onPressed: () {
                context.go('/perfil');
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                appointmentEvents.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No tenés ningún turno guardado.\nSi tenés un turno asignado, podés guardarlo desde el calendario.',
                            textAlign: TextAlign.center,
                            style: textStyle
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.go(
                                '/calendario',
                              );
                            },
                            style: mainButtonDecoration(),
                            child: const Text(
                              'Ir al calendario',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        // if()
                        Center(
                          child: Text(
                            'Próximo turno',
                            style: titleStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (nextAppointment.isNotEmpty)
                          ...nextAppointment.map((appt) {
                            return _AppointmentItem(date: appt.date);
                          }).toList(),
                        if (nextAppointment.isEmpty)
                          Text(
                            'No hay turnos registrados',
                            style: textStyle,
                          ),
                        const Divider(height: 40),
                        Center(
                          child: Text(
                            'Últimos turnos',
                            style: titleStyle
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (previousAppointments.isNotEmpty)
                          ...previousAppointments.map((appt) {
                            return _AppointmentItem(date: appt.date);
                          }).toList(),
                        if (previousAppointments.isEmpty)
                          Text(
                            'No hay turnos registrados',
                            style: textStyle
                          ),
                      ],
                    ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              NewEventDialog.show(
                context,
                initialDate: DateTime.utc(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  3,
                ),
                initialType: EventType.APPOINTMENT,
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            body: Center(child: Text('Error al cargar turnos: $err')),
          ),
    );
  }
}

class _AppointmentItem extends StatelessWidget {
  final DateTime date;

  const _AppointmentItem({required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Fecha: $formattedDate',
            style: textStyle,
          ),
          Text(
            'Hora: $formattedTime',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
