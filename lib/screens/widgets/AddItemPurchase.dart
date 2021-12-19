import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../services/addPoints.dart';
import 'package:circulr/styles.dart';

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
  int depositPeriod = 30; // default deposit period
  late int itemQty;
  int purchaseQty = 1;
  late int unitPrice;
  int totalAmount = 0;
  double formattedPrice = 0;

  // Map<String, dynamic>? paymentIntentData;

  Future<void> initPaymentSheet(context, {required int amount}) async {
    // Navigator.pop(context);
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-circulr-fb9b9.cloudfunctions.net/stripePayment'),
          body: {
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
          testEnv: true,
          merchantCountryCode: 'SG',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      addPurchase();
      purchaseSuccess();
      // Navigator.pop(context);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Payment completed!')),
      // );
    } catch (e) {
      if (e is StripeException) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
                  child: Text('Cancel', style: TextStyle(color: cBlue)),
                ),
                TextButton(
                  onPressed: () async {
                    // makePayment();
                    Navigator.pop(context, 'OK');
                    await initPaymentSheet(context, amount: totalAmount);
                  },
                  child: Text('OK'),
                  style: TextButton.styleFrom(
                      primary: cBeige, backgroundColor: primary),
                ),
              ],
            ));
  }

  // Dialog to display when item purchase has been added to user's profile
  Future<void> purchaseSuccess() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Purchase Added!'),
        content: Text(
            'Item(s) successfully added to your account! You have been rewarded ' +
                purchaseQty.toString() +
                ' point(s).'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Done');
              Navigator.pop(context);
            },
            child: const Text('Done'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: cBlue),
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
        title: const Text('Note: item(s) require a delayed deposit.'),
        content: Text('You will be invoiced for \$' +
            formattedPrice.toStringAsFixed(2) +
            ' if item(s) are not marked returned after ' +
            depositPeriod.toString() +
            ' day(s).'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(color: cBlue)),
          ),
          TextButton(
            onPressed: () {
              addPurchase();
              Navigator.pop(context, 'Add');
              purchaseSuccess();
            },
            child: const Text('Add'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: primary),
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
    DateTime dueDate = DateTime.now().add(Duration(days: depositPeriod));

    bool pastdue = false;
    CollectionReference ref = _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased');

    print('Adding Purchase...');
    addPoints(purchaseQty);

    return ref.add({
      'brand': selectedBrand,
      'qty': purchaseQty,
      'total': totalAmount,
      'deposit type': purchaseType,
      'date': now,
      'due': dueDate,
      'past due': pastdue,
      'deposit period': depositPeriod,
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
                      totalAmount = purchaseQty * unitPrice;
                      print('total: \$\ $totalAmount/100');
                      formattedPrice = totalAmount / 100;
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
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Add Purchase');
              if (purchaseType == 'direct') {
                print('Deposit required.');
                depositAlert();
              } else if (purchaseType == 'delayed') {
                reverseDepositAlert();
              } else {
                addPurchase();
                purchaseSuccess();
              }
            },
            child: const Text('Add Purchase'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: primary),
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

          return ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Deposit Type: ' + data['deposit type']),
                  onTap: () async {
                    unitPrice = data['unit price'].toInt();
                    purchaseType = data['deposit type'];
                    selectedBrand = data['name'];
                    depositPeriod = data['deposit period'];
                    itemId = document.id;
                    totalAmount =
                        unitPrice; // initialize total amount to item's unit price
                    print('purchase type: $purchaseType');
                    print('unit price: $unitPrice');
                    addItemDialog();
                  });
            }).toList(),
          );
        });
  }
}
