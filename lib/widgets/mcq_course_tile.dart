import 'package:aptcoder_application/models/course_model.dart';
import 'package:aptcoder_application/screens/student/course/student_mcq_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class McqCourseTile extends StatelessWidget {
  final CourseModel course;

  const McqCourseTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(course.id)
          .collection('mcqs')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(); // 👈 hides courses without MCQs
        }

        return ListTile(
          leading: const Icon(Icons.quiz, color: Colors.orange),
          title: Text(course.title),
          subtitle: Text("${snapshot.data!.docs.length} questions"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentMcqListScreen(courseId: course.id,)));
          },
        );
      },
    );
  }
}
