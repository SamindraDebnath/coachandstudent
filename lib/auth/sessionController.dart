import 'package:firebase_auth/firebase_auth.dart';

class SessionController {
  static final SessionController _session = SessionController._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;

  factory SessionController(){
    return _session;
  }

  SessionController._internal();

  // Method to get the current user's email
  Future<String?> getCurrentUserEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.email;
      }
      return null; // Return null if user is not logged in
    } catch (e) {
      print("Error getting current user email: $e");
      return null;
    }
  }
}