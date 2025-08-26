import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  /// Create a new class
  Future<void> createClass(String centerId, String coachId) async {
    final classDoc = _db.collection("classes").doc();
    await classDoc.set({
      "centerId": centerId,
      "coachId": coachId,
      "title": "Physics Live Class",
      "subject": "Physics",
      "grade": "12",
      "schedule": {
        "days": ["Mon", "Wed"],
        "start": "18:00",
        "tz": "Asia/Kolkata",
      },
      "priceINR": 500,
      "maxSeats": 50,
      "public": true,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Enroll a student in a class
  Future<void> enrollStudent(String classId, String studentId) async {
    final enrollDoc = _db.collection("enrollments").doc();
    await enrollDoc.set({
      "classId": classId,
      "studentId": studentId,
      "paid": true,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
