import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachandstudent/auth/sessionController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserNameAuthenticate extends StatefulWidget {
  final String userId;
  final Color color;

  const UserNameAuthenticate({
    super.key,
    required this.userId,
    required this.color,
  });

  @override
  State<UserNameAuthenticate> createState() => _UserNameAuthenticateState();
}

class _UserNameAuthenticateState extends State<UserNameAuthenticate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> _getUserData() async {
    final firestore = FirebaseFirestore.instance;

    // Try fetching from "student" collection
    final studentDoc =
    await firestore.collection("student").doc(widget.userId).get();
    if (studentDoc.exists) {
      return {
        "role": "student",
        "studentName": studentDoc["studentName"] ?? "Unknown",
      };
    }

    // Try fetching from "coach" collection
    final coachDoc =
    await firestore.collection("coach").doc(widget.userId).get();
    if (coachDoc.exists) {
      return {
        "role": "coach",
        "centerName": coachDoc["centerName"] ?? "Unknown",
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return Text(
        'Guest',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: widget.color,
        ),
      );
    }

    // Save session userId
    SessionController().userId = _auth.currentUser!.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text(
            "No user data",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          );
        }

        final userData = snapshot.data!;
        String displayName = "Unknown";

        if (userData["role"] == "student") {
          displayName = userData["studentName"];
        } else if (userData["role"] == "coach") {
          displayName = userData["centerName"];
        }

        return Text(
          displayName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
