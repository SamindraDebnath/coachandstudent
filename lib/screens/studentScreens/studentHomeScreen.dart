import 'package:coachandstudent/auth/userNameAuth.dart';
import 'package:coachandstudent/screens/homeScreens/drawerScreen.dart';
import 'package:coachandstudent/screens/homeScreens/homeScreen.dart';
import 'package:coachandstudent/utils/nextScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    nextScreenReplace(context, HomeScreen()
    );
  }

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      drawer: DrawerSlide(),
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "Welcome",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Show user name dynamically
            UserNameAuthenticate(
              userId: _auth.currentUser?.uid ?? "",
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 30),

            // Example dashboard content
            Text(
              "Your Class Overview",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Text("👉 Upcoming Classes\n👉 Notifications"),
          ],
        ),
      ),
    );
  }
}
