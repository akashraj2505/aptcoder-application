import 'package:aptcoder_application/screens/admin/mcq/admin_edit_mcq_screen.dart';
import 'package:aptcoder_application/screens/admin/mcq/admin_mcq_detail_screen.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMcqListScreen extends StatelessWidget {
  final String courseId;

  const AdminMcqListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('mcqs')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No MCQs added yet"));
        }

        final mcqs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: mcqs.length,
          itemBuilder: (context, index) {
            final mcq = mcqs[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(mcq['question']),
                subtitle: Text(
                  "Correct: ${mcq['options'][mcq['correctIndex']]}",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminMcqDetailScreen(mcq: mcq),
                    ),
                  );
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEditMcqScreen(
                            courseId: courseId,
                            mcqDoc: mcq,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      _confirmDelete(context, courseId, mcq.id);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String courseId, String mcqId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete MCQ"),
        content: const Text("Are you sure you want to delete this MCQ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('courses')
                  .doc(courseId)
                  .collection('mcqs')
                  .doc(mcqId)
                  .delete();

              Navigator.pop(context);

              AppSnackBar.show(
                context,
                message: "MCQ deleted successfully",
                type: SnackBarType.success,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
