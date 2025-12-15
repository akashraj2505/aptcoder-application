part of 'student_enrollment_bloc.dart';
abstract class StudentEnrollmentState {}

class StudentEnrollmentInitial extends StudentEnrollmentState {}

class StudentEnrollmentLoading extends StudentEnrollmentState {}

class StudentEnrollmentSuccess extends StudentEnrollmentState {}

class StudentEnrollmentError extends StudentEnrollmentState {
  final String message;
  StudentEnrollmentError(this.message);
}
