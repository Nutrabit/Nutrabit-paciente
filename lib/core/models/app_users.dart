import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final DateTime? birthday;
  final int height;
  final int weight;
  final String gender;
  final bool isActive;
  final String profilePic;
  final String goal;
  final List<Map<String, Object?>> events;
  final List<Timestamp> appointments;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;

  AppUser({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.gender,
    required this.isActive,
    required this.profilePic,
    required this.goal,
    required this.events,
    required this.appointments,
    DateTime? createdAtParam,
    DateTime? modifiedAtParam,
    DateTime? deletedAtParam,
  }) : createdAt = createdAtParam ?? DateTime.now(),
       modifiedAt = modifiedAtParam ?? DateTime.now(),
       deletedAt = deletedAtParam;

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      birthday: data['birthday'] != null
          ? (data['birthday'] as Timestamp).toDate()
          : null,
      height: data['height'] ?? 0,
      weight: data['weight'] ?? 0,
      gender: data['gender'] ?? '',
      isActive: data['isActive'] ?? false,
      profilePic: data['profilePic'] ?? '',
      goal: data['goal'] ?? '',
      events:
          (data['events'] as List?)
              ?.map((e) => Map<String, Object?>.from(e as Map))
              .toList() ??
          [],
      appointments:
          (data['appointments'] as List?)
              ?.map((e) => e as Timestamp)
              .toList() ??
          [],
      createdAtParam:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      modifiedAtParam:
          data['modifiedAt'] != null
              ? (data['modifiedAt'] as Timestamp).toDate()
              : DateTime.now(),
      deletedAtParam:
          data['deletedAt'] != null
              ? (data['deletedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'height': height,
      'weight': weight,
      'gender': gender,
      'isActive': isActive,
      'profilePic': profilePic,
      'goal': goal,
      'events': events,
      'appointments': appointments,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? lastname,
    String? email,
    DateTime? birthday,
    int? height,
    int? weight,
    String? gender,
    bool? isActive,
    String? profilePic,
    String? goal,
    List<Map<String, Object?>>? events,
    List<Timestamp>? appointments,
    DateTime? createdAtParam,
    DateTime? modifiedAtParam,
    DateTime? deletedAtParam,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      profilePic: profilePic ?? this.profilePic,
      goal: goal ?? this.goal,
      events: events ?? this.events,
      appointments: appointments ?? this.appointments,
      createdAtParam: createdAtParam ?? this.createdAt,
      modifiedAtParam: modifiedAtParam ?? this.modifiedAt,
      deletedAtParam: deletedAtParam ?? this.deletedAt,
    );
  }
}
