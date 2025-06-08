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
      final querySnapshot =
          await _db
              .collection('notifications')
              .where('topic', isEqualTo: topic)
              .where(
                'scheduledTime',
                isEqualTo: Timestamp.fromDate(scheduledTime),
              )
              .get();

      final batch = _db.batch();
      print('documentos $querySnapshot.docs');
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('Se eliminaron ${querySnapshot.docs.length} notificaciones.');
    } catch (e) {
      print('Error al eliminar notificaciones: $e');
    }
  }
}
