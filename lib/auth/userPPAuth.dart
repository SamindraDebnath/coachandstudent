import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachandstudent/auth/firebaseAuth.dart';
import 'package:coachandstudent/auth/sessionController.dart';
import 'package:coachandstudent/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserProfilePictureAuthenticate extends StatefulWidget {
  final userId;

  const UserProfilePictureAuthenticate({super.key, required this.userId});

  @override
  State<UserProfilePictureAuthenticate> createState() =>
      _UserProfilePictureAuthenticateState();
}

class _UserProfilePictureAuthenticateState
    extends State<UserProfilePictureAuthenticate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      SessionController().userId = _auth.currentUser?.uid.toString();
      return StreamBuilder(
        stream: users.doc(widget.userId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(child: Text("Loading..."));
          } else if (snapshot.hasData) {
            UserModel userModel = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return CircleAvatar(
              backgroundColor: Colors.grey[400],
              radius: 35,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 33,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: '${userModel.imageUrl}' == ""
                        ? Image.asset(
                        fit: BoxFit.cover, 'assets/images/demoDp.png')
                        : Image.network(
                      fit: BoxFit.cover,
                      ('${userModel.imageUrl}'),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, object, stack) {
                        return Container(
                          child: Image.asset(
                            'assets/images/demoDp.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
          return Text('Loading...');
        },
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 35,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/demoDp.png'),
          radius: 33,
        ),
      );
    }
  }
}
