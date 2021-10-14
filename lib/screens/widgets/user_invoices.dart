import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInvoices extends StatefulWidget {
  const UserInvoices({Key? key}) : super(key: key);

  @override
  _UserInvoicesState createState() => _UserInvoicesState();
}

class _UserInvoicesState extends State<UserInvoices> {
  // DateTime x = DateTime.now().subtract(Duration(days: 30));

  final Stream<QuerySnapshot> _overdueStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_purchased')
      .where('date',
          isLessThanOrEqualTo: DateTime.now().subtract(Duration(days: 30)))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // return Container();
    return StreamBuilder<QuerySnapshot>(
        stream: _overdueStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('No Overdue items.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                      title: Text(data['brand']),
                      subtitle: Text(data['qty'].toString()),
                      onTap: () async {
                        // DateTime returnDate = DateTime.now();

                        // print('Selected: ' +
                        //     data['name'] +
                        //     ' ' +
                        //     data['address'].toString());
                      });
                }).toList(),
              ),
            ],
          );
        });
  }
}
