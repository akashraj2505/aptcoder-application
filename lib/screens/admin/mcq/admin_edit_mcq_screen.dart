import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminEditMcqScreen extends StatefulWidget {
  final String courseId;
  final QueryDocumentSnapshot mcqDoc;

  const AdminEditMcqScreen({
    super.key,
    required this.courseId,
    required this.mcqDoc,
  });

  @override
  State<AdminEditMcqScreen> createState() => _AdminEditMcqScreenState();
}

class _AdminEditMcqScreenState extends State<AdminEditMcqScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController questionCtrl;
  late List<TextEditingController> optionCtrls;
  late int correctIndex;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    questionCtrl =
        TextEditingController(text: widget.mcqDoc['question']);
    optionCtrls = List.generate(
      4,
      (i) => TextEditingController(
        text: widget.mcqDoc['options'][i],
      ),
    );
    correctIndex = widget.mcqDoc['correctIndex'];
  }

  @override
  void dispose() {
    questionCtrl.dispose();
    for (final c in optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit MCQ"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: questionCtrl,
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter question" : null,
                decoration: const InputDecoration(
                  labelText: "Question",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              ...List.generate(4, (i) {
                return InkWell(
                  onTap: () {
                    setState(() => correctIndex = i);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: correctIndex == i
                          ? Colors.green[50]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: correctIndex == i
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          correctIndex == i
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: optionCtrls[i],
                            validator: (v) => v == null || v.isEmpty
                                ? "Option required"
                                : null,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _updateMcq,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update MCQ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateMcq() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('mcqs')
        .doc(widget.mcqDoc.id)
        .update({
      'question': questionCtrl.text.trim(),
      'options': optionCtrls.map((e) => e.text.trim()).toList(),
      'correctIndex': correctIndex,
    });

    if (mounted) {
      AppSnackBar.show(
        context,
        message: "MCQ updated successfully",
        type: SnackBarType.success,
      );
      Navigator.pop(context);
    }
  }
}
