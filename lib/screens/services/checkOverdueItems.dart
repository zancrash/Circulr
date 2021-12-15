import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addInvoice.dart';

Future<int> getDepositPeriod(String docId) async {
  User? user = FirebaseAuth.instance.currentUser;

  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .doc(docId)
      .get()
      .then((snapshot) {
    return snapshot.data()!['deposit period'].toInt();
  });

  print(result);

  return result;
}

void checkOverdueItems() async {
  User? user = FirebaseAuth.instance.currentUser;

  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .where('deposit type', isEqualTo: 'reverse')
      // .where('date', isLessThanOrEqualTo: x)
      .get();
  result.docs.forEach((res) {
    if (DateTime.now().isAfter(res.data()['due'].toDate())) {
      print('Overdue item(s) found...');
      addInvoice(res.data()['brand'], res.data()['qty'],
          res.data()['date'].toDate(), res.data()['total']);
    } else {
      print('item not overdue');
    }
  });
}
