import 'package:aptcoder_application/models/course_model.dart';
import 'package:aptcoder_application/screens/admin/mcq/admin_mcq_list_screen.dart';
import 'package:flutter/material.dart';

class StudentMcqScreen extends StatelessWidget {
  final CourseModel course;
  const StudentMcqScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${course.title} - MCQs")),
      body: AdminMcqListScreen(courseId: course.id),
    );
  }
}
