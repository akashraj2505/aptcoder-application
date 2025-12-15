import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> fetchDashboardStats() async {
    // Courses
    final coursesSnap = await _firestore.collection('courses').get();

    // Students
    final studentsSnap = await _firestore.collection('students').get();

    // MCQs (sum from subcollections)
    int totalMcqs = 0;

    for (final course in coursesSnap.docs) {
      final mcqSnap = await _firestore
          .collection('courses')
          .doc(course.id)
          .collection('mcqs')
          .get();

      totalMcqs += mcqSnap.size;
    }

    return {
      'courses': coursesSnap.size,
      'students': studentsSnap.size,
      'mcqs': totalMcqs,
    };
  }
}
