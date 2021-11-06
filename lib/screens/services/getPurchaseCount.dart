import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getPurchaseCount() async {
  User? user = FirebaseAuth.instance.currentUser;
  int purchaseCount = 0;

  // iterate through user's invoices:
  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .get();
  result.docs.forEach((res) {
    purchaseCount += 1;
  });
  // print(purchaseCount);
  return purchaseCount;
}
