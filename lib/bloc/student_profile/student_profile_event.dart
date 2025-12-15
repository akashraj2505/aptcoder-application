part of 'student_profile_bloc.dart';

abstract class StudentProfileEvent {}

class LoadStudentProfile extends StudentProfileEvent {
  final String uid;
  LoadStudentProfile(this.uid);
}
