import 'package:aptcoder_application/models/course_model.dart';
import 'package:aptcoder_application/widgets/video_screen.dart';
import 'package:flutter/material.dart';

class StudentVideoScreen extends StatelessWidget {
  final CourseModel course;
  const StudentVideoScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: VideoScreen(videoUrl: course.videoUrl!),
    );
  }
}

