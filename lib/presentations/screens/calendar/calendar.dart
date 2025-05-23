import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrabit_paciente/core/models/event_type.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/widgets/newEventDialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/calendar_event.dart';
import 'package:nutrabit_paciente/presentations/providers/events_provider.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  FaIcon _getEventTypeIcon(String typeName) {
  try {
    final type = EventType.values.firstWhere((t) => t.name == typeName);
    return type.icon;
  } catch (e) {
    return const FaIcon(FontAwesomeIcons.circleQuestion); // ícono por defecto
  }
}

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final eventsByDateAsync = ref.watch(eventsByDateProvider);

    final appUser = ref.watch(authProvider);

    return eventsByDateAsync.when(
      data: (eventsByDate) {
        final selectedDayKey = DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        );
        final dayEvents = eventsByDate[selectedDayKey] ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('')),
          body: Column(
            children: [
              cardPatient(
                name: appUser.value!.name,
                lastname: appUser.value!.lastname,
                profilePic: appUser.value!.profilePic,
              ),
              const SizedBox(height: 8),
              TableCalendar<Event>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) {
                  final normalized = DateTime(day.year, day.month, day.day);
                  return eventsByDate[normalized] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFDC607A),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(150, 220, 96, 123),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: const Color(0xFFDC607A)),
                  weekendTextStyle: TextStyle(color: Colors.grey.shade600),
                  outsideTextStyle: TextStyle(color: Colors.grey.shade400),
                ),

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return _buildDayCell(day);
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return _buildDayCell(day, isToday: true);
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return _buildDayCell(
                      day,
                      isSelected: true,
                      context: context,
                    );
                  },
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              //Listar eventos
              Expanded(
                child:
                    dayEvents.isEmpty
                        ? const Center(child: Text('No hay eventos este día'))
                        : ListView.builder(
                          itemCount: dayEvents.length,
                          itemBuilder: (context, i) {
                            final e = dayEvents[i];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFDC607A),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: _getEventTypeIcon(e.type),
                                title: Text(e.title),
                                subtitle: Text(e.description),
                                textColor: Color.fromARGB(255, 0, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              NewEventDialog.show(context, initialDate: DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 3));
            },
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            body: Center(child: Text('Error al cargar eventos: $err')),
          ),
    );
  }
}

class cardPatient extends StatelessWidget {
  final String name;
  final String lastname;
  final String? profilePic;

  const cardPatient({
    super.key,
    required this.name,
    required this.lastname,
    this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    final completeName =
        name.toString().capitalize() + ' ' + lastname.toString().capitalize();
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.2),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromRGBO(236, 218, 122, 0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 15),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          profilePic != null && profilePic!.isNotEmpty
                              ? NetworkImage(profilePic!)
                              : const AssetImage('assets/img/avatar.jpg')
                                  as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            completeName,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildDayCell(
  DateTime day, {
  bool isSelected = false,
  bool isToday = false,
  BuildContext? context,
}) {
  Color bgColor = Colors.transparent;
  Color textColor = const Color(0xFFDC607A); 

  if (isSelected) {
    bgColor = const Color(0xFFDC607A);
    textColor = Colors.white;
  } else if (isToday) {
    bgColor = const Color.fromARGB(80, 220, 96, 123); 
  }


  return GestureDetector(
    onDoubleTap: () {
      if (isSelected && context != null) {
        // Redirigir a otra pantalla:
        GoRouter.of(context).push('/calendario/${day.year}-${day.month}-${day.day}', extra: day);
      }
    },
    child: Container(
      width: 32,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
