import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMcqService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMcq({
    required String courseId,
    required String question,
    required List<String> options,
    required int correctIndex,
    String? explanation,
  }) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('mcqs')
        .add({
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getMcqs(String courseId) async {
    final snap = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('mcqs')
        .get();

    return snap.docs.map((e) {
      return {
        'id': e.id,
        ...e.data(),
      };
    }).toList();
  }

  Future<void> deleteMcq({
    required String courseId,
    required String mcqId,
  }) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('mcqs')
        .doc(mcqId)
        .delete();
  }
}
