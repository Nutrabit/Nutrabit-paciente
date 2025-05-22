import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/core/models/calendar_event.dart';


final eventsStreamProvider = StreamProvider<List<Event>>((ref) {
  final appUser = ref.watch(authProvider).value;
  if (appUser == null) return const Stream.empty();

  final userId = appUser.id;

  return FirebaseFirestore.instance
      .collection('events')
      .where('userid', isEqualTo: userId)
      .snapshots()
      .map((docSnap) {
    final data = <Event>[];
    for (var doc in docSnap.docs) {
      final event = Event.fromMap(doc.id, doc.data());
      data.add(event);
    }

    if (data.isEmpty) return [];

    final List<Event> events = data;
    return events;
  });
});

/// Agrupa los eventos por día
final eventsByDateProvider = Provider<AsyncValue<Map<DateTime, List<Event>>>>((ref) {
  final asyncEvents = ref.watch(eventsStreamProvider);

  return asyncEvents.whenData((events) {
    final map = <DateTime, List<Event>>{};
    for (var event in events) {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      map.putIfAbsent(day, () => []).add(event);
    }
    return map;
  });
});
