import 'package:coachandstudent/screens/coachScreens/coachHomeScreen.dart';
import 'package:coachandstudent/screens/studentScreens/studentHomeScreen.dart';
import 'package:coachandstudent/utils/nextScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);

    try {
      // 🔹 Sign in with Firebase Auth
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCred.user!.uid;

      // 🔹 Check if user exists in "students" collection
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection("student")
          .doc(uid)
          .get();

      if (studentDoc.exists) {
        // Navigate to Student Home
        nextScreenReplace(context, StudentHomePage());
        return;
      }

      // 🔹 Else check if user exists in "coaches" collection
      DocumentSnapshot coachDoc = await FirebaseFirestore.instance
          .collection("coach")
          .doc(uid)
          .get();

      if (coachDoc.exists) {
        // Navigate to Coach Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CoachHomeScreen()),
        );
        return;
      }

      // If neither found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found in Student/Coach records")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Sign in failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign In"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
