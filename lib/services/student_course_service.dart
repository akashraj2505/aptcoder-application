import 'package:aptcoder_application/models/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CourseModel>> getEnrolledCourses(String studentId) async {
    final studentDoc =
        await _firestore.collection('students').doc(studentId).get();

    final enrolled = (studentDoc.data()?['enrolledCourses'] as List? ?? [])
        .map((e) => e['id'])
        .whereType<String>()
        .toList();

    if (enrolled.isEmpty) return [];

    final snapshot = await _firestore
        .collection('courses')
        .where(FieldPath.documentId, whereIn: enrolled)
        .get();

    return snapshot.docs
        .map((doc) => CourseModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
