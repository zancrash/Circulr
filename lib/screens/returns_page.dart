import 'package:circulr_app/screens/widgets/PurchaseForm.dart';
import 'package:circulr_app/screens/widgets/user_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({Key? key}) : super(key: key);

  @override
  _ReturnsPageState createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  int x = 0;
  int overdues = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Item Tracking',
                style: appBarHeader,
              ),
              backgroundColor: primary,
              // bottom: const TabBar(
              //   tabs: <Widget>[
              //     Tab(text: 'Track Purchases'),
              //     Tab(text: 'Track Returns'),
              //   ],
              // ),
            ),
            body: PurchaseForm(), backgroundColor: cBeige,
            // body: TabBarView(
            //   children: [
            //     // Center(child: PurchaseForm()),
            //     Center(
            //       child: PurchaseForm(),
            //     ),
            //     Center(child: UserItems()),
            //   ],
            // ),
          )),
    );
  }

  // Get user's overdue items count
  Future<int> getOverdues() async {
    User? user = FirebaseAuth.instance.currentUser;
    int overdueCount = 0;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    docRef.get().then((snapshot) {
      overdueCount = snapshot['overdue_items'];
    });
    print('overdue count: ' + overdueCount.toString());

    return overdueCount;
  }
}
