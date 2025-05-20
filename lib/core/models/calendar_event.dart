import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  //final String id;
  final String title;
  final String description;
  final String file;
  final String type;
  final DateTime date;

  Event({
    //required this.id,
    required this.title,
    required this.description,
    required this.file,
    required this.type,
    required this.date,
  });

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      //id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      file: map['file'] as String,
      type: map['type'] as String,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
