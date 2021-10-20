import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void>? deleteItem(String docId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  var ref = _firestore
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .doc(docId);

  ref.delete();
}
