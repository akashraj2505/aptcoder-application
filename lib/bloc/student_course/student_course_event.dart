part of 'student_course_bloc.dart';
abstract class StudentCourseEvent {}

class LoadCourses extends StudentCourseEvent {
  final String studentId;
  LoadCourses(this.studentId);
}
