import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Save user to Firestore
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String role,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (role == 'admin') {
      await _firestore.collection('admins').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    if (role == 'student') {
      await _firestore.collection('students').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'enrolledCourses': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get user from Firestore
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Failed to get user data: ${e.toString()}';
    }
  }

  // Update user data
  Future<void> updateUser({
    required String uid,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (data != null) {
        await _firestore.collection(_usersCollection).doc(uid).update(data);
      }
    } catch (e) {
      throw 'Failed to update user data: ${e.toString()}';
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      throw 'Failed to delete user: ${e.toString()}';
    }
  }

  // Get all users with a specific role
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get users: ${e.toString()}';
    }
  }

  Future<void> enrollStudentToCourse({
    required String studentId,
    required String courseId,
  }) async {
    await _firestore.collection('students').doc(studentId).update({
      'enrolledCourses': FieldValue.arrayUnion([courseId]),
    });
  }

  Future<void> removeStudentFromCourse({
    required String studentId,
    required String courseId,
  }) async {
    await _firestore.collection('students').doc(studentId).update({
      'enrolledCourses': FieldValue.arrayRemove([courseId]),
    });
  }

  // Stream of user data
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
    return _firestore.collection(_usersCollection).doc(uid).snapshots();
  }
}
