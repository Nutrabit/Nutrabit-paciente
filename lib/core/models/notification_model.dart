import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String title;
  String description;
  String topic;
  DateTime scheduledTime;
  DateTime? endDate;
  int? repeatEvery;      
  String? urlIcon;
  bool cancel;
  bool sent;
  
  NotificationModel({
    this.id = '',
    required this.title,
    required this.topic,
    required this.description,
    required this.scheduledTime,
    this.endDate,
    this.repeatEvery,
    this.urlIcon,
    this.cancel = false,
    this.sent = false,
  });
  
  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "title": title,
      "description": description,
      "topic": topic,
      "scheduledTime": scheduledTime,  
      "endDate": endDate,
      "repeatEvery": repeatEvery,
      "urlIcon": urlIcon,
      "cancel": cancel,
      "sent": sent,
    };
  }

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: data['id'] ?? doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      topic: data['topic'] ?? '',
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      repeatEvery: data['repeatEvery'],
      urlIcon: data['urlIcon'],
      cancel: data['cancel'] ?? false,
    );
  }


  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? topic,
    DateTime? scheduledTime,
    DateTime? endDate,
    int? repeatEvery, 
    String? urlIcon,
    bool? cancel,
    bool? sent,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      endDate: endDate ?? this.endDate,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      urlIcon: urlIcon ?? this.urlIcon,
      cancel: cancel ?? this.cancel,
      sent: sent ?? this.sent,
    );
  }
}