import 'package:coachandstudent/auth/userNameAuth.dart';
import 'package:coachandstudent/screens/homeScreens/drawerScreen.dart';
import 'package:coachandstudent/screens/homeScreens/homeScreen.dart';
import 'package:coachandstudent/utils/nextScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachHomeScreen extends StatefulWidget {
  const CoachHomeScreen({super.key});

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSlide(),
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              "Coach Dashboard",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (!mounted) return;
              nextScreenReplace(context, HomeScreen());
            },
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
              "Your Coaching Overview",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Text("👉 Upcoming Classes\n👉 Students List\n👉 Notifications"),
          ],
        ),
      ),
    );
  }
}
