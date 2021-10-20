import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class UserInvoices extends StatefulWidget {
  const UserInvoices({Key? key}) : super(key: key);

  @override
  _UserInvoicesState createState() => _UserInvoicesState();
}

class _UserInvoicesState extends State<UserInvoices> {
  // DateTime x = DateTime.now().subtract(Duration(days: 30));

  // final Stream<QuerySnapshot> _overdueStream = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(FirebaseAuth.instance.currentUser?.uid)
  //     .collection('items_purchased')
  //     .where('date',
  //         isLessThanOrEqualTo: DateTime.now().subtract(Duration(days: 30)))
  //     .snapshots();

  Map<String, dynamic>? paymentIntentData;

  // move to services file in production...
  Future<void> makePayment() async {
    final url = Uri.parse(
        'https://us-central1-circulr-fb9b9.cloudfunctions.net/stripePayment');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    paymentIntentData = json.decode(response.body);

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
            applePay: true,
            googlePay: true,
            // confirmPayment: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'CA',
            merchantDisplayName: 'Circulr'));
    setState(() {});

    displayPaymentSheet();
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invoice cleared.')));
      clearInvoice();
    } catch (e) {
      print(e);
    }
  }

  Future<void>? clearInvoice() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var collection = _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('invoices')
        .doc(selectedInvoice);
    // var snapshot =
    //     await collection.where('issued', isEqualTo: invoiceDate).get();
    // await snapshot.docs.first.reference.delete();
    collection.delete();

    // sendEmail(name: 'Circulr', email: user?.providerData[0].email.toString(), subject: subject, message: message)
  }

  DateTime? invoiceDate;
  String? selectedInvoice;

  final Stream<QuerySnapshot> _overdueStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('invoices')
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
                      subtitle: Text(data['issued'].toDate().toString()),
                      onTap: () async {
                        // invoiceDate = data['issued'].toDate();
                        print(document.id);
                        selectedInvoice = document.id;
                        makePayment();
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
