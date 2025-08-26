import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ClassDetailScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final String classId;
  final String studentId;

  ClassDetailScreen({super.key, required this.classId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Class Details")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _firestoreService.enrollStudent(classId, studentId);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enrolled Successfully!"))
            );
          },
          child: const Text("Enroll Now"),
        ),
      ),
    );
  }
}
