import 'file_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileModel {
  final String id; 
  final String title;
  final FileType type;
  final String url;
  final DateTime date;
  final String userId;

  FileModel({
    required this.id, 
    required this.title,
    required this.type,
    required this.url,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'url': url,
      'date': Timestamp.fromDate(date), // Convertir a Timestamp
      'userId': userId,
    };
  }

  factory FileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
  return FileModel(
    id: id,
    title: json['title'] ?? '',
    type: FileType.values.firstWhere((e) => e.name == json['type']),
    url: json['url'] ?? '',
    date: (json['date'] as Timestamp).toDate(),
    userId: json['userId'] ?? '',
  );
}
}