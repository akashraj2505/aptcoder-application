part of 'student_profile_bloc.dart';

abstract class StudentProfileState {}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  final String name;
  final String email;
  final int enrolledCount;

  StudentProfileLoaded({
    required this.name,
    required this.email,
    required this.enrolledCount,
  });
}

class StudentProfileError extends StudentProfileState {
  final String message;
  StudentProfileError(this.message);
}
