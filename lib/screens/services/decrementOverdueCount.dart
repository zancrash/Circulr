import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Run function to decrement user's overdue items count
Future<void> decrementOverdueCount() async {
  User? user = FirebaseAuth.instance.currentUser;
  DateTime x = DateTime.now().subtract(Duration(days: 30));

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .doc(user?.uid)
      .update({'overdue_items': FieldValue.increment(-1)});
}
