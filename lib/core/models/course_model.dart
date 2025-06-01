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

  final bool showCourse;
  final bool showInscription;
  final DateTime? showFrom;
  final DateTime? showUntil;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;

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
    required this.showCourse,
    required this.showInscription,
    this.showFrom,
    this.showUntil,
    this.createdAt,
    this.modifiedAt,
    this.deletedAt,
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
      showCourse: data['showCourse'] ?? false,
      showInscription: data['showInscription'] ?? false,
      showFrom: (data['showFrom'] as Timestamp?)?.toDate(),
      showUntil: (data['showUntil'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp?)?.toDate(),
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'inscriptionStart': inscriptionStart,
      'inscriptionEnd': inscriptionEnd,
      'courseStart': courseStart,
      'courseEnd': courseEnd,
      'picture': picture,
      'inscriptionLink': inscriptionLink,
      'webPage': webPage,
      'showCourse': showCourse,
      'showInscription': showInscription,
      'showFrom': showFrom,
      'showUntil': showUntil,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': deletedAt,
    };
  }
}