import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addInvoice.dart';

void checkOverdueItems() async {
  User? user = FirebaseAuth.instance.currentUser;
  DateTime x = DateTime.now().subtract(Duration(days: 30));

  int itemCount = 0;

  // query firestore for user items more than 30 days old
  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .where('deposit type', isEqualTo: 'reverse')
      .where('date', isLessThanOrEqualTo: x)
      .get();
  result.docs.forEach((res) {
    addInvoice(
        res.data()['brand'], res.data()['qty'], res.data()['date'].toDate());
    itemCount +=
        1; // for each item more than 30 days old, increment item count variable
  });
  print('Overdue items: ${itemCount}');
  // print('Checking overdue items...');
  // overdueCount = itemCount;
  // return itemCount;
}
