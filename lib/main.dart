import 'package:aptcoder_application/bloc/admin/admin_dashboard_bloc.dart';
import 'package:aptcoder_application/bloc/admin_add_content/admin_add_content_bloc.dart';
import 'package:aptcoder_application/bloc/admin_student/admin_student_bloc.dart';
import 'package:aptcoder_application/bloc/student_course/student_course_bloc.dart';
import 'package:aptcoder_application/bloc/student_dashboard/student_dashboard_bloc.dart';
import 'package:aptcoder_application/bloc/student_enrollment/student_enrollment_bloc.dart';
import 'package:aptcoder_application/bloc/view_course/view_course_bloc.dart';
import 'package:aptcoder_application/firebase_options.dart';
import 'package:aptcoder_application/screens/admin/course/admin_add_content_screen.dart';
import 'package:aptcoder_application/screens/admin/dashboard/admin_dashboard_screen.dart';
import 'package:aptcoder_application/screens/admin/auth/admin_login_screen.dart';
import 'package:aptcoder_application/screens/admin/auth/admin_signup_screen.dart';
import 'package:aptcoder_application/screens/admin/course/admin_course_list_screen.dart';
import 'package:aptcoder_application/screens/shared/splash_screen.dart';
import 'package:aptcoder_application/screens/shared/role_selection_screen.dart';
import 'package:aptcoder_application/screens/student/auth/student_login_screen.dart';
import 'package:aptcoder_application/screens/student/course/student_course_list.dart';
import 'package:aptcoder_application/screens/student/course/student_mcq_screen.dart';
import 'package:aptcoder_application/screens/student/course/student_pdf_screen.dart';
import 'package:aptcoder_application/screens/student/course/student_video_screen.dart';
import 'package:aptcoder_application/screens/student/dashboard/student_dashboard_screen.dart';
import 'package:aptcoder_application/screens/student/dashboard/student_profile_screen.dart';
import 'package:aptcoder_application/services/admin_content_service.dart';
import 'package:aptcoder_application/services/admin_dashboard_service.dart';
import 'package:aptcoder_application/services/auth_service.dart';
import 'package:aptcoder_application/services/student_course_service.dart';
import 'package:aptcoder_application/services/student_dashboard_service.dart';
import 'package:aptcoder_application/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AdminDashboardBloc(AdminDashboardService()),
        ),
        BlocProvider(create: (_) => AdminAddContentBloc(AdminContentService())),
        BlocProvider(create: (_) => CourseBloc()),
        BlocProvider(
          create: (_) => AdminStudentBloc(AuthService(), UserService()),
        ),
        BlocProvider(create: (_) => StudentEnrollmentBloc(UserService())),
        // BlocProvider(create: (_) => StudentCourseBloc(StudentCourseService())),
      ],
      child: MaterialApp(
        title: 'APTCODER',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        /// 👇 ENTRY SCREEN - Now starts with Splash
        initialRoute: '/',

        /// 👇 ROUTES
        routes: {
          '/': (context) => const SplashScreen(),
          '/roleSelection': (context) => const RoleSelectionScreen(),

          // Admin routes
          '/adminSignup': (context) => const AdminSignupScreen(),
          '/adminLogin': (context) => const AdminLoginScreen(),
          '/adminDashboard': (context) => const AdminDashboardScreen(),
          '/adminAddContent': (context) => const AdminAddContentScreen(),
          // Student routes
          '/studentLogin': (context) => const StudentLoginScreen(),
          '/studentDashboard': (context) => const StudentDashboardScreen(),
          '/studentProfile': (context) => const StudentProfileScreen(),
          '/adminCourses': (context) => const AdminCoursesScreen(),

          // '/studentCourses': (context) => const StudentCourseList(),
        },
      ),
    );
  }
}
