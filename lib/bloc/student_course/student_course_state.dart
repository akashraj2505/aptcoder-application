part of 'student_course_bloc.dart';
abstract class StudentCourseState {}

class StudentCourseLoading extends StudentCourseState {}

class StudentCourseLoaded extends StudentCourseState {
  final List<CourseModel> courses;
  StudentCourseLoaded(this.courses);
}

class StudentCourseError extends StudentCourseState {
  final String message;
  StudentCourseError(this.message);
}
