import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAddMcqScreen extends StatefulWidget {
  final String courseId;

  const AdminAddMcqScreen({super.key, required this.courseId});

  @override
  State<AdminAddMcqScreen> createState() => _AdminAddMcqScreenState();
}

/// 🔹 Model for one MCQ form
class McqFormModel {
  final TextEditingController questionCtrl = TextEditingController();
  final List<TextEditingController> optionCtrls = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int correctIndex = 0;

  void dispose() {
    questionCtrl.dispose();
    for (final c in optionCtrls) {
      c.dispose();
    }
  }
}

class _AdminAddMcqScreenState extends State<AdminAddMcqScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<McqFormModel> mcqs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    mcqs.add(McqFormModel()); // start with 1 MCQ
  }

  @override
  void dispose() {
    for (final mcq in mcqs) {
      mcq.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Add MCQs",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...List.generate(mcqs.length, (index) {
                return _buildMcqCard(index);
              }),

              const SizedBox(height: 16),

              // ➕ Add another MCQ (max 10)
              if (mcqs.length < 10)
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      mcqs.add(McqFormModel());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add another MCQ"),
                ),

              const SizedBox(height: 24),

              _buildSaveButton(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MCQ CARD =================

  Widget _buildMcqCard(int index) {
    final mcq = mcqs[index];
    final labels = ['A', 'B', 'C', 'D'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                "Question ${index + 1}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (mcqs.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      mcq.dispose();
                      mcqs.removeAt(index);
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Question
          TextFormField(
            controller: mcq.questionCtrl,
            maxLines: 2,
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Enter question" : null,
            decoration: const InputDecoration(
              hintText: "Enter question",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Options
          ...List.generate(4, (i) {
            final isSelected = mcq.correctIndex == i;

            return InkWell(
              onTap: () {
                setState(() {
                  mcq.correctIndex = i;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: mcq.optionCtrls[i],
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Option ${labels[i]} required"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Option ${labels[i]}",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ================= SAVE BUTTON =================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveMcqs,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Save MCQs",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  // ================= SAVE LOGIC =================

  Future<void> _saveMcqs() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final batch = FirebaseFirestore.instance.batch();
      final mcqCollection = FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('mcqs');

      for (final mcq in mcqs) {
        batch.set(mcqCollection.doc(), {
          'question': mcq.questionCtrl.text.trim(),
          'options': mcq.optionCtrls.map((e) => e.text.trim()).toList(),
          'correctIndex': mcq.correctIndex,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'MCQs Added Succesfully',
          type: SnackBarType.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Error :$e',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
