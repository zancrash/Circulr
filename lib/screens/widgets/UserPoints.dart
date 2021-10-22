import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPoints extends StatefulWidget {
  const UserPoints({Key? key}) : super(key: key);

  @override
  _UserPointsState createState() => _UserPointsState();
}

class _UserPointsState extends State<UserPoints> {
  // final Stream<QuerySnapshot> _pointsStream = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(FirebaseAuth.instance.currentUser?.uid)
  //     .collection('items_purchased')
  //     .snapshots();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  int getPoints() {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    int points = 0;

    documentReference.get().then((snapshot) {
      points = snapshot['points'].toInt();
    });

    return points;
  }

  // int userPoints = getPoints();

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
            Text(
              getPoints().toString(),
              style: optionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
