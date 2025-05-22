import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nutrabit_paciente/core/models/calendar_event.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';
import 'package:nutrabit_paciente/widgets/newEventDialog.dart';

class CalendarDayPatient extends ConsumerWidget {
  final DateTime fecha;
  const CalendarDayPatient({required this.fecha, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    final asyncEventsByDate = ref.watch(eventsByDateProvider);
    final diaClave = DateTime(fecha.year, fecha.month, fecha.day);

    return Scaffold(
      backgroundColor: const Color(0xFFF4E9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4E9F7),
        title: const Text(
          "Día de calendario",
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
              fechaFormateada,
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
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
                        final eventosDelDia = eventsMap.entries
                            .where((entry) =>
                                entry.key.year == diaClave.year &&
                                entry.key.month == diaClave.month &&
                                entry.key.day == diaClave.day)
                            .expand((entry) => entry.value)
                            .toList();

                        if (eventosDelDia.isEmpty) {
                          return const Center(
                            child: Text("No hay eventos para este día."),
                          );
                        }

                        return ListView.builder(
                          itemCount: eventosDelDia.length,
                          itemBuilder: (context, index) {
                            final evento = eventosDelDia[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Center(
                                      child: Text(
                                        evento.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    
                                    if (evento.file != null && evento.file!.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          evento.file!,
                                          width: double.infinity,
                                          height: 160,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image, size: 100),
                                        ),
                                      )
                                    else
                                      const Icon(Icons.image_not_supported, size: 100),

                                    const SizedBox(height: 13),

                                    
                                    Text(
                                      evento.description,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text("Error al cargar eventos: $error")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NewEventDialog.show(context); 
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
