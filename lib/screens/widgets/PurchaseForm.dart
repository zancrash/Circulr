import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';
import '../services/getInvoiceCount.dart';
import '../services/addPoints.dart';
import '../services/getPurchaseCount.dart';
import '../services/checkOverdueItems.dart';
import 'AddItemPurchase.dart';
import 'ReturnItemPurchase.dart';

int? purchaseCount;

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  String? selectedBrand;
  int selectedQty = 1;
  String? purchaseType;

  Future<void>? addPurchase() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    DateTime now = new DateTime.now();
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

  Future<void> invoicesAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Unpaid Invoices'),
              content: Text(
                  'Please pay any outstanding invoices to add more purchases.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                  style: TextButton.styleFrom(
                      primary: cBeige, backgroundColor: cBlue),
                ),
              ],
            ));
  }

  Future<void> purchaseInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Adding Purchased Items'),
        content: Container(
          height: 160,
          child: Column(
            children: [
              Text(
                  'When you are buying an item from one of our partnered brands, make sure to track it so that you remember to return it.',
                  style: body),
              SizedBox(height: 10),
              Text(
                  'For items that normally have a deposit if you show the cashier you have it tracked, you can avoid the deposit altogether!',
                  style: body),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Done'),
            child: const Text('Done'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: cBlue),
          ),
        ],
      ),
    );
  }

  Future<void> returnInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Adding Purchased Items'),
        content: Container(
          height: 40,
          child: Column(
            children: [
              Text(
                  'Track your returns to earn points, and remove them from your profile.',
                  style: body),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Done'),
            child: const Text('Done'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: cBlue),
          ),
        ],
      ),
    );
  }

  Future<void> beginPurchase() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              // title: const Text('Select Brand'),
              titlePadding: EdgeInsets.fromLTRB(35, 10, 5, 0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select brand',
                    ),
                    CloseButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),
              content: Container(
                width: double.minPositive,
                child: AddItemPurchase(),
              ),
            ));
  }

  Future<void> beginReturn() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              // title: const Text('Select Return Type'),
              titlePadding: EdgeInsets.fromLTRB(35, 10, 5, 0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Return Type',
                    ),
                    CloseButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),

              content: Container(
                width: double.minPositive,
                child: ReturnItemPurchase(),
              ),
            ));
  }

  String depositType = '';
  Color color = Colors.transparent;
  String currentItem = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 250,
        child: Column(
          children: [
            Card(
              color: primary,
              child: InkWell(
                onTap: () async {
                  checkOverdueItems();
                  if (await getInvoiceCount() != 0) {
                    invoicesAlert();
                  } else {
                    beginPurchase();
                  }
                },
                child: SizedBox(
                  width: 300,
                  height: 130,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(
                          Icons.storefront_outlined,
                          size: 62,
                          color: cBeige,
                        ),
                        title:
                            Text('Add Purchased Item', style: purchaseButton),
                        subtitle: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                                'Track items purchased from our partnered brands.',
                                style: purchaseButtonText),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Icon(Icons.info),
                            onPressed: () {
                              purchaseInfo();
                            },
                            style: TextButton.styleFrom(
                                primary: cBeige, backgroundColor: primary),
                          ),
                          // const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: cBlue,
              child: InkWell(
                onTap: () async {
                  purchaseCount = await getPurchaseCount();
                  // print(purchaseCount);
                  beginReturn();
                },
                child: SizedBox(
                  width: 300,
                  height: 130,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(
                          Icons.shopping_basket_outlined,
                          size: 62,
                          color: cBeige,
                        ),
                        title: Text('Return Item', style: purchaseButton),
                        subtitle: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                                'Return items to collection sites to earn points.',
                                style: purchaseButtonText),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // TextButton(
                          //   child: const Text('BUY TICKETS'),
                          //   onPressed: () {/* ... */},
                          // ),
                          // const SizedBox(width: 8),
                          TextButton(
                            child: Icon(Icons.info),
                            onPressed: () {
                              returnInfo();
                            },
                            style: TextButton.styleFrom(
                                primary: cBeige, backgroundColor: cBlue),
                          ),
                          // const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
