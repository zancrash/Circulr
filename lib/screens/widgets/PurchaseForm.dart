import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../services/getInvoiceCount.dart';
import '../services/addPoints.dart';

// import '../services/addPurchase.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final Stream<QuerySnapshot> _brandStream =
      FirebaseFirestore.instance.collection('brands').snapshots();
  String? selectedBrand;

  int selectedQty = 1;

  String? purchaseType;

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
      'qty': selectedQty,
      'deposit type': purchaseType,
      'date': now,
      'due': dueDate,
      'past due': pastdue,
    });
  }

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

  Future<void> purchaseSuccess() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Purchase Added'),
        content:
            const Text('Item has been successfully added to your account.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Done'),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

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
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  bool requiresDeposit = false;
  String depositType = '';
  Color color = Colors.transparent;
  String currentItem = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<QuerySnapshot>(
          stream: _brandStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('No brands found.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                      tileColor: currentItem == document.id
                          ? Colors.grey[300]
                          : Colors.transparent,
                      // selectedTileColor: Colors.blue,
                      title: Text(data['name']),
                      subtitle: Text(data['item_type']),
                      onTap: () {
                        requiresDeposit = data['deposit'];
                        depositType = data['deposit type'];
                        selectedBrand = data['name'];
                        purchaseType = data['deposit type'];
                        setState(() {
                          currentItem = document.id;
                        });
                        // print(document.id);
                        // print('Selected: $selectedBrand');
                        print('deposit type: ' + depositType);
                      });
                }).toList(),
              ),
            );
          }),
      SpinBox(
        min: 1,
        max: 50,
        value: 1,
        onChanged: (value) {
          selectedQty = value.toInt();
          print(value);
        },
      ),
      ElevatedButton(
          onPressed: () async {
            if (await getInvoiceCount() > 0) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Overdue Items'),
                        content: const Text(
                            'You have items out that are past due, please pay any outstanding invoices to add more purchases'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ));
            } else {
              if (selectedBrand == null) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please select brand.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              } else {
                if (depositType == 'direct') {
                  print('Deposit required.');
                  depositAlert();
                } else if (depositType == 'reverse') {
                  reverseDepositAlert();
                } else {
                  addPurchase();
                  purchaseSuccess();
                }
              }
            }
          },
          child: Text('Add Purchase')),
    ]);
  }
}
