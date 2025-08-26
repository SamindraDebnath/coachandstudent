import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachandstudent/screens/coachScreens/coachHomeScreen.dart';
import 'package:coachandstudent/screens/homeScreens/homeScreen.dart';
import 'package:coachandstudent/screens/studentScreens/studentHomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Authenticate({super.key});

  Future<String?> _getUserRole(String uid) async {
    final firestore = FirebaseFirestore.instance;

    // Check student collection
    final studentDoc = await firestore.collection("student").doc(uid).get();
    if (studentDoc.exists) return "student";

    // Check coach collection
    final coachDoc = await firestore.collection("coach").doc(uid).get();
    if (coachDoc.exists) return "coach";

    return null; // no role found
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      // Not signed in → go to Home/Login
      return const HomeScreen();
    }

    final uid = _auth.currentUser!.uid;

    return FutureBuilder<String?>(
      future: _getUserRole(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("No user data found")),
          );
        }

        if (snapshot.data == "student") {
          return const StudentHomePage();
        } else if (snapshot.data == "coach") {
          return const CoachHomeScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
