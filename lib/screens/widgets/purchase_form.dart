import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'locationsDropdown.dart';
import 'locations.dart';
import 'package:circulr_app/screens/widgets/locationsDropdown.dart';
import '../services/getInvoiceCount.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  // final Stream<QuerySnapshot> _brandStream =
  //     FirebaseFirestore.instance.collection('brands').snapshots();
  //
  final Stream<QuerySnapshot> _brandStream =
      FirebaseFirestore.instance.collection('brands').snapshots();
  String? selectedBrand;
  int _currentIntValue = 1;

  int selectedQty = 1;

  Future<void>? addPurchase() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    bool pastdue = false;
    CollectionReference ref = _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased');

    print('adding..');
    // Object? data;
    return ref.add({
      'brand': selectedBrand,
      'qty': selectedQty,
      // 'location': selectedLoc,
      'date': now,
      'past due': pastdue,
    });
  }

  _handleValueChanged(num value) {
    if (value is int) {
      setState(() => _currentIntValue = value);
      selectedQty = _currentIntValue;
    }
  }

  // Future<void> updateUser() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users
  //       .doc(user?.uid)
  //       // .update({'past_due': true})
  //       .update({'overdue_items': overdueCount})
  //       // .update({'overdue_items': FieldValue.increment(1)})
  //       .then((value) => print("User Updated"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }

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
          .showSnackBar(SnackBar(content: Text('Deposit Successful')));
      addPurchase();
      purchaseSuccess();
      // addReturned(); // add item to returned items collection
      // deleteItem(); // delete item after successful deposit.
      // userReturnLate(); // decrement user overdue items count.
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
              actions: [TextButton(onPressed: makePayment, child: Text('OK'))],
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

  // Function to increment user's overdue items count if an item is more than 30 days old
  // int overdueCount = 0;
  void userPastDue() async {
    User? user = FirebaseAuth.instance.currentUser;
    DateTime x = DateTime.now().subtract(Duration(days: 30));

    int itemCount = 0;

    // iterate through user's item purchases:
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased')
        .where('date', isLessThanOrEqualTo: x)
        .get();
    result.docs.forEach((res) {
      // print(res.data());
      // print(res);
      // print(res.exists);
      itemCount += 1;
    });
    print(itemCount);
    // overdueCount = itemCount;
    print('userPastDue executed.');
  }

  // Get user's overdue items count
  Future<int> getOverdues() async {
    User? user = FirebaseAuth.instance.currentUser;
    int overdueCount = 0;

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    await docRef.get().then((snapshot) {
      overdueCount = snapshot['overdue_items'];
    });

    return overdueCount.toInt();
  }

  // var selectedLoc = LocationsDropdownState.selectedLoc;
  // int overdueCount = 0;

  bool requiresDeposit = false;
  // int useroverduecount = 0;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();

    color = Colors.transparent;
  }

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
                        selectedBrand = data['name'];
                        setState(() {
                          currentItem = document.id;
                        });
                        print(document.id);
                        print('Selected: $selectedBrand');
                      });
                }).toList(),
              ),
            );
          }),
      NumberPicker(
        value: _currentIntValue,
        minValue: 1,
        maxValue: 10,
        axis: Axis.horizontal,
        onChanged: _handleValueChanged,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black26),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => setState(() {
              final newValue = _currentIntValue - 1;
              _currentIntValue = newValue.clamp(1, 10);
            }),
          ),
          Text('QTY: $_currentIntValue'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() {
              final newValue = _currentIntValue + 1;
              _currentIntValue = newValue.clamp(1, 10);
            }),
          ),
        ],
      ),
      ElevatedButton(
          onPressed: () async {
            // print(useroverduecount);
            // getInvoiceCount();
            // int invoiceCount = await getInvoiceCount();
            // print('count::' + invoiceCount.toString());
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
                if (requiresDeposit) {
                  print('Deposit required.');
                  depositAlert();
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
