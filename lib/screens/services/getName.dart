import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circulr/styles.dart';

class GetName extends StatelessWidget {
  // final String documentId;

  // GetPoints(this.documentId);

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
          if (data['name'].toString() == 'null') {
            // return Text('Circulr User', style: name);
            return Text(data['email'].substring(0, data['email'].indexOf('@')),
                style: name);
          } else {
            return Text(data['name'].toString(), style: name);
          }
        }

        // return CircularProgressIndicator();
        return Text("loading");
      },
    );
  }
}

// Future<String?> getUserEmail() async {
//   User? user = FirebaseAuth.instance.currentUser;

//   DocumentReference documentReference =
//       FirebaseFirestore.instance.collection('users').doc(user?.uid);

//   String? userEmail;
//   userEmail = user?.providerData[0].email;
//   // await documentReference.get().then((snapshot) {
//   //   userEmail = user?.providerData[0].email;
//   //   print(userEmail);
//   // });

//   return userEmail;
// }
