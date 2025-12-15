import 'package:aptcoder_application/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_enrollment_event.dart';
part 'student_enrollment_state.dart';

class StudentEnrollmentBloc
    extends Bloc<StudentEnrollmentEvent, StudentEnrollmentState> {
  final UserService userService;

  StudentEnrollmentBloc(this.userService)
      : super(StudentEnrollmentInitial()) {
    on<EnrollStudentToCourse>(_enroll);
  }

  Future<void> _enroll(
    EnrollStudentToCourse event,
    Emitter<StudentEnrollmentState> emit,
  ) async {
    emit(StudentEnrollmentLoading());
    try {
      await userService.updateUser(
        uid: event.studentId,
        data: {
          'enrolledCourses': FieldValue.arrayUnion([event.courseId]),
        },
      );
      emit(StudentEnrollmentSuccess());
    } catch (e) {
      emit(StudentEnrollmentError(e.toString()));
    }
  }
}
