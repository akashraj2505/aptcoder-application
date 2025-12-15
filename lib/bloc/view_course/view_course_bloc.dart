import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view_course_event.dart';
part 'view_course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CourseBloc() : super(CourseInitial()) {
    on<LoadCourses>(_loadCourses);
    on<DeleteCourse>(_deleteCourse);
  }

  Future<void> _loadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());

    try {
      final snapshot = await firestore.collection('courses').get();

      final courses = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _deleteCourse(
    DeleteCourse event,
    Emitter<CourseState> emit,
  ) async {
    try {
      await firestore.collection('courses').doc(event.courseId).delete();
      add(LoadCourses());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
