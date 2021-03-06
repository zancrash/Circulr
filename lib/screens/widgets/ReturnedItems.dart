import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr/styles.dart';

class ReturnedItems extends StatefulWidget {
  const ReturnedItems({Key? key}) : super(key: key);

  @override
  _ReturnedItemsState createState() => _ReturnedItemsState();
}

class _ReturnedItemsState extends State<ReturnedItems> {
  DateTime? invoiceDate;
  String? selectedInvoice;

  final Stream<QuerySnapshot> _returnedStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_returned')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // return Container();
    return StreamBuilder<QuerySnapshot>(
        stream: _returnedStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('No Overdue items.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Container(
                child: Text('Your returned items will be listed here.',
                    style: placeHolder),
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text('x' + data['qty'].toString() + ' ' + data['brand']),
                subtitle: Text('Returned: ' + data['date'].toDate().toString()),
              );
            }).toList(),
          );
        });
  }
}
