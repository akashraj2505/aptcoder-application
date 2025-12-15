import 'package:aptcoder_application/models/course_model.dart';
import 'package:aptcoder_application/widgets/pdf_screen.dart';
import 'package:flutter/material.dart';

class StudentPdfScreen extends StatelessWidget {
  final CourseModel course;

  const StudentPdfScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfScreen(pdfUrl: course.pdfUrl!, title: course.title),
    );
  }
}
