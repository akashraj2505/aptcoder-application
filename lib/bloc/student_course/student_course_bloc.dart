import 'package:aptcoder_application/models/course_model.dart';
import 'package:aptcoder_application/services/student_course_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_course_event.dart';
part 'student_course_state.dart';

class StudentCourseBloc
    extends Bloc<StudentCourseEvent, StudentCourseState> {
  final StudentCourseService service;

  StudentCourseBloc(this.service) : super(StudentCourseLoading()) {
    on<LoadCourses>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCourses event,
    Emitter<StudentCourseState> emit,
  ) async {
    emit(StudentCourseLoading());
    try {
      final courses = await service.getEnrolledCourses(event.studentId);
      emit(StudentCourseLoaded(courses));
    } catch (e) {
      emit(StudentCourseError(e.toString()));
    }
  }
}
