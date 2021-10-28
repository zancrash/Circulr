import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to increment user's overdue items count if an item is more than 30 days old
// int overdueCount = 0;
void incrementOverdueCount() async {
  User? user = FirebaseAuth.instance.currentUser;
  DateTime x = DateTime.now().subtract(Duration(days: 30));

  int itemCount = 0;

  // iterate through user's item purchases:
  var result = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('items_purchased')
      .where('date', isLessThanOrEqualTo: x)
      .get();
  result.docs.forEach((res) {
    // print(res.data());
    // print(res);
    // print(res.exists);
    itemCount += 1;
  });
  print(itemCount);
  // overdueCount = itemCount;
  print('incrementOverdueCount executed.');
}
