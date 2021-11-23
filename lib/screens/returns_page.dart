import 'dart:async';

import 'package:circulr_app/screens/widgets/PurchaseForm.dart';
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
  // void timeTest() async {
  //   print('test');
  // }

  // Timer? timer;
  // @override
  // void initState() {
  //   super.initState();
  //   timer = Timer.periodic(Duration(seconds: 5), (Timer t) => timeTest());
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  int x = 0;
  int overdues = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: Text(
                'Item Tracking',
                style: appBarHeader,
              ),
              backgroundColor: primary,
            ),
            body: PurchaseForm(),
            backgroundColor: cBeige,
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
