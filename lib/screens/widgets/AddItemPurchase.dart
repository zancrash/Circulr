import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../services/getInvoiceCount.dart';
import '../services/addPoints.dart';

class AddItemPurchase extends StatefulWidget {
  const AddItemPurchase({Key? key}) : super(key: key);

  @override
  _AddItemPurchaseState createState() => _AddItemPurchaseState();
}

class _AddItemPurchaseState extends State<AddItemPurchase> {
  bool requiresDeposit = false;
  var selectedLoc;
  String? selectedBrand;
  late String itemId;
  String purchaseType = '';
  late int itemQty;
  int purchaseQty = 1;

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
            // applePay: true,
            // googlePay: true,
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
          .showSnackBar(SnackBar(content: Text('Deposit Successful')));
      addPurchase();
      purchaseSuccess();
    } catch (e) {
      print(e);
    }
  }

  // Dialog to display when item requires a direct deposit before adding to user's profile
  Future<void> depositAlert() async {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Deposit Required'),
              content: Text('This item requires a direct deposit to add.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      makePayment();
                      Navigator.pop(context, 'OK');
                    },
                    child: Text('OK')),
              ],
            ));
  }

  // Dialog to display when item purchase has been added to user's profile
  Future<void> purchaseSuccess() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Purchase Added'),
        content:
            const Text('Item has been successfully added to your account.'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'Done'),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Dialog to display when item is a reverse deposit item
  Future<void> reverseDepositAlert() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Note: This item requires a delayed deposit.'),
        content: const Text(
            'You will be invoiced for \$20 in 30 days if item is not returned within the time-frame.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addPurchase();
              Navigator.pop(context, 'Add');
              purchaseSuccess();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void>? addPurchase() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    DateTime dueDate = DateTime.now().add(Duration(days: 30));

    bool pastdue = false;
    CollectionReference ref = _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased');

    print('Adding Purchase...');
    addPoints(1);

    // Object? data;

    return ref.add({
      'brand': selectedBrand,
      'qty': purchaseQty,
      'deposit type': purchaseType,
      'date': now,
      'due': dueDate,
      'past due': pastdue,
    });
  }

  Future<void> addItemDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('How many units did you purchase from $selectedBrand ?'),
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
              height: 50,
              child: Column(
                children: [
                  SpinBox(
                    min: 1,
                    max: 100,
                    value: 1,
                    onChanged: (value) {
                      purchaseQty = value.toInt();
                      print(value);
                    },
                  ),
                ],
              ));
        }),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, 'Add Purchase');
              if (purchaseType == 'direct') {
                print('Deposit required.');
                depositAlert();
              } else if (purchaseType == 'reverse') {
                reverseDepositAlert();
              } else {
                addPurchase();
                purchaseSuccess();
              }
            },
            child: const Text('Add Purchase'),
          ),
        ],
      ),
    );
  }

  final Stream<QuerySnapshot> _brandStream =
      FirebaseFirestore.instance.collection('brands').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _brandStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error Occurred.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // return ListView(
          //   shrinkWrap: true,
          //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //     Map<String, dynamic> data =
          //         document.data()! as Map<String, dynamic>;
          //     return Card(
          //       child: ListTile(
          //           title: Text(data['name']),
          //           subtitle: Text(data['item_type']),
          //           onTap: () async {
          //             // If user has unpaid invoices...

          //             purchaseType = data['deposit type'];
          //             selectedBrand = data['name'];
          //             itemId = document.id;
          //             print(purchaseType);
          //             addItemDialog();
          //           }),
          //     );
          //   }).toList(),
          // );

          return ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['item_type']),
                  onTap: () async {
                    // If user has unpaid invoices...

                    purchaseType = data['deposit type'];
                    selectedBrand = data['name'];
                    itemId = document.id;
                    print(purchaseType);
                    // Navigator.pop(context); // causes error
                    // depositAlert();
                    addItemDialog();
                    // DateTime returnDate = DateTime.now();
                  });
            }).toList(),
          );
        });
  }
}
