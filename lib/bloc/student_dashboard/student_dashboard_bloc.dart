import 'package:aptcoder_application/services/student_dashboard_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_dashboard_event.dart';
part 'student_dashboard_state.dart';

class StudentDashboardBloc
    extends Bloc<StudentDashboardEvent, StudentDashboardState> {
  final StudentDashboardService service;

  StudentDashboardBloc(this.service)
      : super(StudentDashboardInitial()) {
    on<LoadStudentDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadStudentDashboard event,
    Emitter<StudentDashboardState> emit,
  ) async {
    emit(StudentDashboardLoading());

    try {
      final data = await service.loadDashboard(event.studentId);

      emit(
        StudentDashboardLoaded(
          courseCount: data['courseCount'] ?? 0,
          videoCount: data['videoCount'] ?? 0,
          pdfCount: data['pdfCount'] ?? 0,
          mcqCount: data['mcqCount'] ?? 0,
        ),
      );
    } catch (e) {
      emit(StudentDashboardError(e.toString()));
    }
  }
}