import 'package:aptcoder_application/services/admin_dashboard_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardService service;

  AdminDashboardBloc(this.service) : super(AdminDashboardInitial()) {
    on<LoadAdminDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadAdminDashboard event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(AdminDashboardLoading());

    try {
      final data = await service.fetchDashboardStats();

      emit(
        AdminDashboardLoaded(
          courses: data['courses'],
          students: data['students'],
          mcqs: data['mcqs'],
        ),
      );
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }
}
