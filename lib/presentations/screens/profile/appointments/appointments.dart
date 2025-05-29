import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';
import 'package:intl/intl.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: Text(
                    'Próximo turno',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (nextAppointment.isNotEmpty)
                  ...nextAppointment.map((appt) {
                    return _AppointmentItem(date: appt.date);
                  }).toList(),
                const Divider(height: 40),
                Text(
                  'Últimos turnos',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if(previousAppointments.isNotEmpty)
                  ...previousAppointments.map((appt) {
                    return _AppointmentItem(date: appt.date);
                  }).toList(),
                if(previousAppointments.isEmpty) 
                  Text('No hay turnos registrados', style: const TextStyle(fontFamily: 'Inter', fontSize: 18))
              ],
            ),
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
            style: const TextStyle(fontFamily: 'Inter', fontSize: 18),
          ),
          Text(
            'Hora: $formattedTime',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 18),
          ),
        ],
      ),
    );
  }
}
