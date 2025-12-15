part of 'admin_dashboard_bloc.dart';
abstract class AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final int?courses;
  final int? students;
  final int?mcqs;

  AdminDashboardLoaded({
    required this.courses,
    required this.students,
    required this.mcqs,
  });
}

class AdminDashboardError extends AdminDashboardState {
  final String message;

  AdminDashboardError(this.message);
}
