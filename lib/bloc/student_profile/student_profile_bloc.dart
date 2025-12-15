import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'student_profile_event.dart';
part 'student_profile_state.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvent, StudentProfileState> {
  StudentProfileBloc() : super(StudentProfileLoading()) {
    on<LoadStudentProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadStudentProfile event,
    Emitter<StudentProfileState> emit,
  ) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(event.uid)
          .get();

      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(event.uid)
          .get();

      emit(
        StudentProfileLoaded(
          name: userDoc['name'],
          email: userDoc['email'],
          enrolledCount:
              (studentDoc['enrolledCourses'] as List).length,
        ),
      );
    } catch (e) {
      emit(StudentProfileError(e.toString()));
    }
  }
}
