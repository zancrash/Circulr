import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUserOverdueCount(int overdueCount) {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  return users
      .doc(user?.uid)
      // .update({'past_due': true})
      .update({'overdue_items': overdueCount})
      // .update({'overdue_items': FieldValue.increment(1)})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}
