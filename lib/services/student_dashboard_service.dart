import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> loadDashboard(String studentId) async {
  final studentDoc =
      await _firestore.collection('students').doc(studentId).get();

  final data = studentDoc.data();
  if (data == null) return _emptyCounts();

  // ✅ FIXED: read `id` key
  final enrolledCourses = (data['enrolledCourses'] as List? ?? [])
      .map((e) {
        if (e is String) return e;
        if (e is Map && e['id'] != null) {
          return e['id'] as String;
        }
        return null;
      })
      .whereType<String>()
      .toList();

  if (enrolledCourses.isEmpty) return _emptyCounts();

  final courseSnapshots = await _firestore
      .collection('courses')
      .where(FieldPath.documentId, whereIn: enrolledCourses)
      .get();

  int videoCount = 0;
  int pdfCount = 0;
  int mcqCount = 0;

  for (final course in courseSnapshots.docs) {
    if ((course['videoUrl'] ?? '').toString().isNotEmpty) videoCount++;
    if ((course['pdfUrl'] ?? '').toString().isNotEmpty) pdfCount++;

    final mcqs = await course.reference.collection('mcqs').get();
    mcqCount += mcqs.docs.length;
  }

  return {
    'courseCount': courseSnapshots.docs.length,
    'videoCount': videoCount,
    'pdfCount': pdfCount,
    'mcqCount': mcqCount,
  };
}


  Map<String, int> _emptyCounts() {
    return {
      'courseCount': 0,
      'videoCount': 0,
      'pdfCount': 0,
      'mcqCount': 0,
    };
  }
}
