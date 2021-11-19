import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getInvoiceCount() async {
  User? user = FirebaseAuth.instance.currentUser;
  int invoiceCount = 0;

  // iterate through user's invoices:
  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('invoices')
      .get();
  result.docs.forEach((res) {
    invoiceCount += 1;
  });
  print('Invoices: ${invoiceCount}');
  // overdueCount = itemCount;
  return invoiceCount;
}
