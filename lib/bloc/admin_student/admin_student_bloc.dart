import 'package:aptcoder_application/services/auth_service.dart';
import 'package:aptcoder_application/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_student_event.dart';
part 'admin_student_state.dart';

class AdminStudentBloc extends Bloc<AdminStudentEvent, AdminStudentState> {
  final AuthService authService;
  final UserService userService;

  AdminStudentBloc(this.authService, this.userService)
    : super(AdminStudentInitial()) {
    on<LoadStudents>(_loadStudents);
    on<CreateStudent>(_createStudent);
    on<LoadStudentById>(_loadStudentById);
    on<UpdateStudent>(_updateStudent);
    on<DeleteStudent>(_deleteStudent);
  }

  Future<void> _loadStudents(
    LoadStudents event,
    Emitter<AdminStudentState> emit,
  ) async {
    emit(AdminStudentLoading());
    try {
      final students = await userService.getUsersByRole('student');
      emit(AdminStudentLoaded(students));
    } catch (e) {
      emit(AdminStudentError(e.toString()));
    }
  }

  Future<void> _createStudent(
    CreateStudent event,
    Emitter<AdminStudentState> emit,
  ) async {
    emit(AdminStudentLoading());

    try {
      // 1️⃣ Create user with temporary password
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: 'Temp@12345',
      );

      final uid = cred.user!.uid;

      // 2️⃣ Send reset password email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);

      // 3️⃣ Save student data
      await FirebaseFirestore.instance.collection('students').doc(uid).set({
        'uid': uid,
        'name': event.name,
        'email': event.email,
        'enrolledCourses': event.enrolledCourses,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4️⃣ Save role
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': event.name,
        'email': event.email,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      add(LoadStudents());
      emit(AdminStudentSuccess());
    } catch (e) {
      emit(AdminStudentError(e.toString()));
    }
  }

  // 🔹 Load single student
  Future<void> _loadStudentById(
    LoadStudentById event,
    Emitter<AdminStudentState> emit,
  ) async {
    emit(AdminStudentLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(event.studentId)
          .get();

      emit(AdminStudentDetailLoaded(doc.data()!));
    } catch (e) {
      emit(AdminStudentError(e.toString()));
    }
  }

  // 🔹 Update student
  Future<void> _updateStudent(
    UpdateStudent event,
    Emitter<AdminStudentState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(event.studentId)
          .update({
            'name': event.name,
            'enrolledCourses': event.enrolledCourses,
          });

      emit(AdminStudentSuccess());
    } catch (e) {
      emit(AdminStudentError(e.toString()));
    }
  }

  // 🔹 Delete student
  Future<void> _deleteStudent(
    DeleteStudent event,
    Emitter<AdminStudentState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(event.studentId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.studentId)
          .delete();

      emit(AdminStudentSuccess());
      add(LoadStudents());
    } catch (e) {
      emit(AdminStudentError(e.toString()));
    }
  }
}
