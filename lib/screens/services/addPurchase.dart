import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addPoints.dart';

Future<void>? addReverseDepositPurchase(String selectedBrand, int selectedQty) {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  DateTime dueDate = DateTime.now().add(Duration(days: 30));

  bool pastdue = false;
  CollectionReference ref = _firestore
      .collection('users')
      .doc(user?.uid)
      .collection('reverse deposit purchases');

  print('adding..');
  // Object? data;
  return ref.add({
    'brand': selectedBrand,
    'qty': selectedQty,
    'date': now,
    'due': dueDate,
    'past due': pastdue,
  });
}

Future<void>? addDirectDepositPurchase(String selectedBrand, int selectedQty) {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  DateTime dueDate = DateTime.now().add(Duration(days: 30));

  bool pastdue = false;
  CollectionReference ref = _firestore
      .collection('users')
      .doc(user?.uid)
      .collection('direct deposit purchases');

  print('adding..');
  // Object? data;
  return ref.add({
    'brand': selectedBrand,
    'qty': selectedQty,
    'date': now,
    'due': dueDate,
    'past due': pastdue,
  });
}

Future<void>? addPurchase(String selectedBrand, int selectedQty) {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  DateTime dueDate = DateTime.now().add(Duration(days: 30));

  bool pastdue = false;
  CollectionReference ref = _firestore
      .collection('users')
      .doc(user?.uid)
      .collection('non deposit purchases');

  print('adding..');
  addPoints(1);
  // Object? data;
  return ref.add({
    'brand': selectedBrand,
    'qty': selectedQty,
    'date': now,
    'due': dueDate,
    'past due': pastdue,
  });
}
