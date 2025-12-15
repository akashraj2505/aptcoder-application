part of 'view_course_bloc.dart';

abstract class CourseEvent {}

class LoadCourses extends CourseEvent {}

class DeleteCourse extends CourseEvent {
  final String courseId;
  DeleteCourse(this.courseId);
}
