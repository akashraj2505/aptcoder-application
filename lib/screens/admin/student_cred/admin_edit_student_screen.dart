import 'package:aptcoder_application/bloc/admin_student/admin_student_bloc.dart';
import 'package:aptcoder_application/bloc/view_course/view_course_bloc.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEditStudentScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const AdminEditStudentScreen({super.key, required this.student});

  @override
  State<AdminEditStudentScreen> createState() =>
      _AdminEditStudentScreenState();
}

class _AdminEditStudentScreenState extends State<AdminEditStudentScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;

  final Set<Map<String, String>> selectedCourses = {};

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.student['name']);
    emailCtrl = TextEditingController(text: widget.student['email']);

    for (final c in widget.student['enrolledCourses'] ?? []) {
      selectedCourses.add({'id': c['id'], 'title': c['title']});
    }

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
                  message: 'Student updated successfully!',
                  type: SnackBarType.success,
                );
                Navigator.pop(context);
                context.read<AdminStudentBloc>().add(LoadStudents());
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
                /// 🔷 HEADER (same as Create)
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    children: [
                      _backButton(context),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit Student",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Update student details",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 🔷 BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputCard(
                          icon: Icons.person_outline,
                          label: "Full Name",
                          hint: "Student full name",
                          controller: nameCtrl,
                          gradient: [Colors.purple.shade400, Colors.purple.shade600],
                        ),

                        const SizedBox(height: 16),

                        _buildInputCard(
                          icon: Icons.email_outlined,
                          label: "Email Address",
                          hint: "student@example.com",
                          controller: emailCtrl,
                          enabled: false, // 🔒 Disabled
                          gradient: [Colors.pink.shade400, Colors.pink.shade600],
                        ),

                        const SizedBox(height: 24),

                        _courseSelection(),

                        const SizedBox(height: 32),

                        _updateButton(),
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

  /// ---------------- HELPERS ----------------

  Widget _courseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Course Enrollment",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseLoaded) {
              return Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: _cardDecoration(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.courses.length,
                  itemBuilder: (_, i) {
                    final course = state.courses[i];
                    final isSelected = selectedCourses.any(
                      (c) => c['id'] == course['id'],
                    );

                    return CheckboxListTile(
                      title: Text(course['title']),
                      value: isSelected,
                      activeColor: Colors.purple.shade600,
                      onChanged: (v) {
                        setState(() {
                          v!
                              ? selectedCourses.add({
                                  'id': course['id'],
                                  'title': course['title'],
                                })
                              : selectedCourses.removeWhere(
                                  (c) => c['id'] == course['id'],
                                );
                        });
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _updateButton() {
    return BlocBuilder<AdminStudentBloc, AdminStudentState>(
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
          ),
          child: InkWell(
            onTap: isLoading
                ? null
                : () {
                    context.read<AdminStudentBloc>().add(
                          UpdateStudent(
                            studentId: widget.student['uid'],
                            name: nameCtrl.text.trim(),
                            enrolledCourses: selectedCourses.toList(),
                          ),
                        );
                  },
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Update Student Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );

  Widget _backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<Color> gradient,
    bool enabled = true,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
