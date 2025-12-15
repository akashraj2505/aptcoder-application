import 'package:aptcoder_application/bloc/student_course/student_course_bloc.dart';
import 'package:aptcoder_application/bloc/student_dashboard/student_dashboard_bloc.dart';
import 'package:aptcoder_application/bloc/student_profile/student_profile_bloc.dart';
import 'package:aptcoder_application/screens/student/dashboard/student_dashboard_view.dart';
import 'package:aptcoder_application/services/student_course_service.dart';
import 'package:aptcoder_application/services/student_dashboard_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentId = FirebaseAuth.instance.currentUser!.uid;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              StudentDashboardBloc(StudentDashboardService())
                ..add(LoadStudentDashboard(studentId)),
        ),
        BlocProvider(
          create: (_) =>
              StudentCourseBloc(StudentCourseService())
                ..add(LoadCourses(studentId)),
        ),
        BlocProvider(
          create: (_) =>
              StudentProfileBloc()..add(LoadStudentProfile(studentId)),
        ),
      ],
      child: const StudentDashboardView(),
    );
  }
}
