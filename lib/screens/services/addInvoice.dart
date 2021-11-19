import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkInvoiceExists.dart';

addInvoice(String brand, int qty, DateTime date) async {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = new DateTime.now();
  CollectionReference ref =
      _firestore.collection('users').doc(user?.uid).collection('invoices');

  print('adding to invoices');
  // check to see if invoice for item has already been issued
  bool exists = await checkInvoiceExists(date);
  // print(exists);

  if (exists == false) {
    ref.add({
      'brand': brand,
      'qty': qty,
      'amount due': 0.00,
      'item purchase date': date,
      'issued': now,
    });
    print('Invoice issued.');
  } else {
    print('Invoice not issued.');
  }
}
