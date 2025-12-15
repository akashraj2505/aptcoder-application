part of 'student_dashboard_bloc.dart';
abstract class StudentDashboardEvent {}

class LoadStudentDashboard extends StudentDashboardEvent {
  final String studentId;

  LoadStudentDashboard(this.studentId);
}
