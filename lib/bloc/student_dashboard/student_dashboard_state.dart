part of 'student_dashboard_bloc.dart';
abstract class StudentDashboardState {}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final int courseCount;
  final int videoCount;
  final int pdfCount;
  final int mcqCount;

  StudentDashboardLoaded({
    required this.courseCount,
    required this.videoCount,
    required this.pdfCount,
    required this.mcqCount,
  });
}

class StudentDashboardError extends StudentDashboardState {
  final String message;

  StudentDashboardError(this.message);
}
