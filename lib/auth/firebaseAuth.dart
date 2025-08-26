import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachandstudent/auth/sessionController.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

// Collection refs
CollectionReference users = firestore.collection('users');
CollectionReference accounts = firestore
    .collection('users')
    .doc(SessionController().userId)
    .collection('accounts');