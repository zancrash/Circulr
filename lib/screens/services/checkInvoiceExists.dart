import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkInvoiceExists(DateTime date) async {
  User? user = FirebaseAuth.instance.currentUser;
  bool exists = false;

  // Query user invoices to see if invoice for product has already been issued.
  print('Checking if invoice already issued.');
  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('invoices')
      .where('item purchase date', isEqualTo: date)
      .get();
  result.docs.forEach((res) {
    exists = res.exists;
  });
  return exists;
}
