import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/course_model.dart';

/// SERVICE
class CourseService {
  final FirebaseFirestore _firestore;

  CourseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Course>> fetchAllCourses() async {
    final query = await _firestore
        .collection('courses')
        .where('showCourse', isEqualTo: true)
        .get();

    return query.docs.map((doc) => Course.fromFirestore(doc)).toList();
  }
}

/// PROVIDER
final courseServiceProvider = Provider<CourseService>((ref) {
  return CourseService();
});

final courseListProvider = FutureProvider<List<Course>>((ref) async {
  final service = ref.watch(courseServiceProvider);
  return service.fetchAllCourses();
});