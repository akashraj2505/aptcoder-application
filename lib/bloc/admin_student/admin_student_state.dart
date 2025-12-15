part of 'admin_student_bloc.dart';

abstract class AdminStudentState {}

class AdminStudentInitial extends AdminStudentState {}

class AdminStudentLoading extends AdminStudentState {}

class AdminStudentLoaded extends AdminStudentState {
  final List<Map<String, dynamic>> students;
  AdminStudentLoaded(this.students);
}

class AdminStudentDetailLoaded extends AdminStudentState {
  final Map<String, dynamic> student;
  AdminStudentDetailLoaded(this.student);
}

class AdminStudentSuccess extends AdminStudentState {}

class AdminStudentError extends AdminStudentState {
  final String message;
  AdminStudentError(this.message);
}
