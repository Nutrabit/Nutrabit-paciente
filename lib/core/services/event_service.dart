import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadEvent({
    required Uint8List fileBytes,
    required String fileName,
    required String title,
    required String description,
    required String type,
    required DateTime dateTime,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final userId = user.uid;

    final ref = _storage.ref().child('images/$userId/$fileName');
    final uploadTask = await ref.putData(fileBytes);
    final fileUrl = await uploadTask.ref.getDownloadURL();

    await _firestore.collection('events').add({
      'date': dateTime,
      'description': description.trim(),
      'file': fileUrl,
      'title': title.trim(),
      'type': type.trim(),
      'userid': userId,
    });
  }
}