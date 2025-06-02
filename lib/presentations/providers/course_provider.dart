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

    final now = DateTime.now();

    final courses = query.docs
        .map((doc) => Course.fromFirestore(doc))
        .where((course) {
          final from = course.showFrom;
          final until = course.showUntil;

          if (from == null && until == null) return true;
          if (from == null) return now.isBefore(until!);
          if (until == null) return now.isAfter(from);

          return now.isAfter(from) && now.isBefore(until);
        })
        .toList();

    courses.sort((a, b) {
      final aDate = a.courseStart ?? DateTime(2100); 
      final bDate = b.courseStart ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });

    return courses;
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