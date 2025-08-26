import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateClassScreen extends StatelessWidget {
  final String coachId;
  const CreateClassScreen({super.key, required this.coachId});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Class")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Class Title")),
            TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: "Subject")),
            TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: "Grade")),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Price (INR)")),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Create"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("classes").add({
                  "coachId": coachId,
                  "title": titleCtrl.text,
                  "subject": subjectCtrl.text,
                  "grade": gradeCtrl.text,
                  "priceINR": int.tryParse(priceCtrl.text) ?? 0,
                  "createdAt": FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
