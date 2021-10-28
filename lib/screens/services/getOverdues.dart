import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Get user's overdue items count
Future<int> getOverdues() async {
  User? user = FirebaseAuth.instance.currentUser;
  int overdueCount = 0;

  DocumentReference docRef =
      FirebaseFirestore.instance.collection('users').doc(user?.uid);

  await docRef.get().then((snapshot) {
    overdueCount = snapshot['overdue_items'];
  });

  return overdueCount.toInt();
}
