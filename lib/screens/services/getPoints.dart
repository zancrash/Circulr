import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetPoints extends StatelessWidget {
  // final String documentId;

  // GetPoints(this.documentId);
  static const TextStyle optionStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          return Text(data['points'].toString(), style: optionStyle);
        }

        return Text("loading");
      },
    );
  }
}

Future<int> getPoints() async {
  User? user = FirebaseAuth.instance.currentUser;

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(user?.uid);

  late int points;

  await documentReference.get().then((snapshot) {
    points = snapshot['points'].toInt();
    print(points.toString());
  });

  return points;
}
