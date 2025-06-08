import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/notification_model.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createNotification(NotificationModel notification) async {
    final docRef = _db.collection('notifications').doc();
    final notificationId = docRef.id;
    final newNotification = notification.copyWith(id: notificationId);
    await docRef.set(newNotification.toMap());
  }

  Future<void> cancelNotification(String id) async {
    await _db.collection('notifications').doc(id).update({"cancel": true});
  }

  Future<void> deleteNotificationsByTopicAndTime({
    required String topic,
    required DateTime scheduledTime,
  }) async {
    try {
    final querySnapshot = await _db
        .collection('notifications')
        .where('topic', isEqualTo: topic)
        .where(
          'scheduledTime',
          isEqualTo: Timestamp.fromDate(scheduledTime),
        )
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      await doc.reference.delete();

      print('Se eliminó una notificación: ${doc.id}');
    } else {
      print('No se encontraron notificaciones para eliminar.');
    }
  } catch (e) {
      print('Error al eliminar notificaciones: $e');
    }
  }
}
