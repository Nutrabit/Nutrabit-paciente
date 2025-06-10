import 'package:cloud_firestore/cloud_firestore.dart';

class InterestItem {
  final String id;
  final String title;
  final String url;
  final DateTime createdAt;
  final DateTime modifiedAt;

  InterestItem({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory InterestItem.fromMap(Map<String, dynamic> map, String id) {
    return InterestItem(
      id: id,
      title: map['title'],
      url: map['url'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      modifiedAt: (map['modifiedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
  return {
    'id': id, 
    'title': title,
    'url': url,
    'createdAt': Timestamp.fromDate(createdAt),
    'modifiedAt': Timestamp.fromDate(modifiedAt),
  };
  }

  InterestItem copyWith({
    String? id,
    String? title,
    String? url,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return InterestItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}
