import 'package:aptcoder_application/bloc/admin/admin_dashboard_bloc.dart';
import 'package:aptcoder_application/bloc/admin_student/admin_student_bloc.dart';
import 'package:aptcoder_application/bloc/view_course/view_course_bloc.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCreateStudentScreen extends StatefulWidget {
  const AdminCreateStudentScreen({super.key});

  @override
  State<AdminCreateStudentScreen> createState() =>
      _AdminCreateStudentScreenState();
}

class _AdminCreateStudentScreenState extends State<AdminCreateStudentScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final Set<Map<String, String>> selectedCourses = {};

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.white,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AdminStudentBloc, AdminStudentState>(
            listener: (context, state) {
              if (state is AdminStudentSuccess) {
                AppSnackBar.show(
                  context,
                  message:
                      'Student account created. A password setup email has been sent. Check Your Spam!',
                  type: SnackBarType.success,
                );

                context.read<AdminDashboardBloc>().add(LoadAdminDashboard());
                Navigator.pop(context);
              }

              if (state is AdminStudentError) {
                AppSnackBar.show(
                  context,
                  message: state.message,
                  type: SnackBarType.error,
                );
              }
            },
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create New Student",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Register a new student account",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student Name Card
                        _buildInputCard(
                          icon: Icons.person_outline_rounded,
                          label: "Full Name",
                          hint: "Enter student's full name",
                          controller: nameCtrl,
                          gradient: [Colors.purple.shade400, Colors.purple.shade600],
                        ),

                        const SizedBox(height: 16),

                        // Student Email Card
                        _buildInputCard(
                          icon: Icons.email_outlined,
                          label: "Email Address",
                          hint: "student@example.com",
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          gradient: [Colors.pink.shade400, Colors.pink.shade600],
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "Course Enrollment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Select courses to enroll the student",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Courses List Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: BlocBuilder<CourseBloc, CourseState>(
                            builder: (context, state) {
                              if (state is CourseLoading) {
                                return Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade600),
                                    ),
                                  ),
                                );
                              }

                              if (state is CourseLoaded) {
                                if (state.courses.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.purple.shade100, Colors.pink.shade100],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.library_books_outlined,
                                              size: 48,
                                              color: Colors.purple.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "No Courses Available",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Create courses first to enroll students",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Container(
                                  constraints: const BoxConstraints(maxHeight: 300),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    shrinkWrap: true,
                                    itemCount: state.courses.length,
                                    itemBuilder: (context, index) {
                                      final course = state.courses[index];
                                      final isSelected = selectedCourses.any(
                                        (c) => c['id'] == course['id'],
                                      );

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.purple.shade50
                                              : Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.purple.shade300
                                                : Colors.grey.shade200,
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: CheckboxListTile(
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          title: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.purple.shade400,
                                                      Colors.pink.shade400,
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.menu_book_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  course['title'],
                                                  style: TextStyle(
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                    color: Colors.grey.shade800,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          activeColor: Colors.purple.shade600,
                                          checkColor: Colors.white,
                                          value: isSelected,
                                          onChanged: (v) {
                                            setState(() {
                                              if (v == true) {
                                                selectedCourses.add({
                                                  'id': course['id'],
                                                  'title': course['title'],
                                                });
                                              } else {
                                                selectedCourses.removeWhere(
                                                  (c) => c['id'] == course['id'],
                                                );
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),

                        // Selected Courses Count
                        if (selectedCourses.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.purple.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.purple.shade600,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${selectedCourses.length} course(s) selected",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.purple.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // Submit Button
                        BlocBuilder<AdminStudentBloc, AdminStudentState>(
                          builder: (context, state) {
                            final isLoading = state is AdminStudentLoading;

                            return Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.purple.shade400, Colors.pink.shade400],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.shade300.withOpacity(0.5),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          if (nameCtrl.text.trim().isEmpty ||
                                              emailCtrl.text.trim().isEmpty) {
                                            AppSnackBar.show(
                                              context,
                                              message: 'Please fill all required fields',
                                              type: SnackBarType.warning,
                                            );
                                            return;
                                          }

                                          context.read<AdminStudentBloc>().add(
                                            CreateStudent(
                                              name: nameCtrl.text.trim(),
                                              email: emailCtrl.text.trim(),
                                              enrolledCourses: selectedCourses.toList(),
                                            ),
                                          );
                                        },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.person_add, color: Colors.white, size: 22),
                                              SizedBox(width: 8),
                                              Text(
                                                "Create Student Account",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<Color> gradient,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gradient[0], width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}