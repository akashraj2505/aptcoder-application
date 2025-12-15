part of 'admin_student_bloc.dart';

abstract class AdminStudentEvent {}

class LoadStudents extends AdminStudentEvent {}

class LoadStudentById extends AdminStudentEvent {
  final String studentId;
  LoadStudentById(this.studentId);
}

class CreateStudent extends AdminStudentEvent {
  final String name;
  final String email;
  final List<Map<String, String>> enrolledCourses;

  CreateStudent({
    required this.name,
    required this.email,
    required this.enrolledCourses,
  });
}

class UpdateStudent extends AdminStudentEvent {
  final String studentId;
  final String name;
  final List<Map<String, String>> enrolledCourses;

  UpdateStudent({
    required this.studentId,
    required this.name,
    required this.enrolledCourses,
  });
}

class DeleteStudent extends AdminStudentEvent {
  final String studentId;
  DeleteStudent(this.studentId);
}
