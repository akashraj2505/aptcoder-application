part of 'student_enrollment_bloc.dart';
abstract class StudentEnrollmentEvent {}

class EnrollStudentToCourse extends StudentEnrollmentEvent {
  final String studentId;
  final String courseId;

  EnrollStudentToCourse({
    required this.studentId,
    required this.courseId,
  });
}
