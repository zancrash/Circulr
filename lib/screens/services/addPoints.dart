import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'getPoints.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> addPoints() async {
  User? user = FirebaseAuth.instance.currentUser;

  int updatedPoints = await getPoints() + 1;

  return users
      .doc(user?.uid)
      .update({'points': updatedPoints})
      .then((value) => print("User Points Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}
