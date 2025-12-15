import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMcqDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot mcq;

  const AdminMcqDetailScreen({super.key, required this.mcq});

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(mcq['options']);
    final correctIndex = mcq['correctIndex'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("MCQ Details"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mcq['question'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(options.length, (i) {
              final isCorrect = i == correctIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.circle_outlined,
                      color: isCorrect ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(options[i])),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
