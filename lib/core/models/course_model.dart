import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String? description;
  final DateTime? inscriptionStart;
  final DateTime? inscriptionEnd;
  final DateTime? courseStart;
  final DateTime? courseEnd;
  final String? picture;
  final String? inscriptionLink;
  final String? webPage;

  Course({
    required this.id,
    required this.title,
    this.description,
    this.inscriptionStart,
    this.inscriptionEnd,
    this.courseStart,
    this.courseEnd,
    this.picture,
    this.inscriptionLink,
    this.webPage,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      inscriptionStart: (data['inscriptionStart'] as Timestamp?)?.toDate(),
      inscriptionEnd: (data['inscriptionEnd'] as Timestamp?)?.toDate(),
      courseStart: (data['courseStart'] as Timestamp?)?.toDate(),
      courseEnd: (data['courseEnd'] as Timestamp?)?.toDate(),
      picture: data['picture'],
      inscriptionLink: data['inscriptionLink'],
      webPage: data['webPage'],
    );
  }
} 