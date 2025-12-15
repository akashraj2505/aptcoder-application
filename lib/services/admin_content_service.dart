import 'package:cloud_firestore/cloud_firestore.dart';

class AdminContentService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveCourse({
    required String title,
    required String description,
    String? videoUrl,
    String? pdfUrl,
  }) async {
    await _firestore.collection('courses').add({
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> updateCourse({
  required String courseId,
  required String title,
  required String description,
  String? videoUrl,
  String? pdfUrl,
}) async {
  await _firestore.collection('courses').doc(courseId).update({
    'title': title,
    'description': description,
    'videoUrl': videoUrl,
    'pdfUrl': pdfUrl,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

}
