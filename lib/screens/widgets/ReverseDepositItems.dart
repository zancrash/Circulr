import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReverseDepositItems extends StatefulWidget {
  const ReverseDepositItems({Key? key}) : super(key: key);

  @override
  _ReverseDepositItemsState createState() => _ReverseDepositItemsState();
}

class _ReverseDepositItemsState extends State<ReverseDepositItems> {
  User? user = FirebaseAuth.instance.currentUser;

  final Stream<QuerySnapshot> _userItemsStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_purchased')
      .where('deposit type', isEqualTo: 'reverse')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _userItemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error Occurred.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                    title: Text(data['qty'].toString() + ' x ' + data['brand']),
                    subtitle: Text('Due: ' + data['due'].toDate().toString()),
                    onTap: () async {
                      print('Selected: ' +
                          data['brand'] +
                          ' ' +
                          data['qty'].toString());
                    }),
                // children: <Widget>[
                //   // ElevatedButton(
                //   //     onPressed: () => {print('test')},
                //   //     child: Text('Pay Deposit')),
                //   Text(
                //     'QTY: ' + data['qty'].toString(),
                //     textAlign: TextAlign.left,
                //   )
                //   // ListTile(
                //   //     // title: Text(data['brand']),
                //   //     subtitle: Text('QTY: ' + data['qty'].toString()),
                //   //     // subtitle: Text(data['qty'].toString()),
                //   //     onTap: () async {
                //   //       // DateTime returnDate = DateTime.now();

                //   //       print('Selected: ' +
                //   //           data['name'] +
                //   //           ' ' +
                //   //           data['address'].toString());
                //   //     }),
                // ],
              );
            }).toList(),
          );
        });
  }
}
