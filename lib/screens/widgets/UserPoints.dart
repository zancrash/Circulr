import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/getPoints.dart';

class UserPoints extends StatefulWidget {
  const UserPoints({Key? key}) : super(key: key);

  @override
  _UserPointsState createState() => _UserPointsState();
}

class _UserPointsState extends State<UserPoints> {
  int userPoints = 0;

  // Future<int> getPoints() async {
  //   User? user = FirebaseAuth.instance.currentUser;

  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection('users').doc(user?.uid);

  //   int points = 0;

  //   await documentReference.get().then((snapshot) {
  //     setState(() {
  //       points = snapshot['points'].toInt();
  //     });
  //   });
  //   return points;
  // }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text(
              'Your Points:',
              style: optionStyle,
            ),
            GetPoints(),
            // Text(
            //   userPoints.toString(),
            //   style: optionStyle,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }

  // @override
  // void afterFirstLayout(BuildContext context) async {
  //   // Calling the same function "after layout" to resolve the issue.
  //   userPoints = await getPoints();
  // }
}
