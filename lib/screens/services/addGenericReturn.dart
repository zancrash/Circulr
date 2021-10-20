import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void>? addGenericReturn(int qty, String location) {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  bool pastdue = false;
  CollectionReference ref = _firestore
      .collection('users')
      .doc(user?.uid)
      .collection('items_returned');

  print('adding..');
  return ref.add({
    'brand': 'Generic Jar',
    'qty': qty,
    'location': location,
    'date': now,
  });
}
