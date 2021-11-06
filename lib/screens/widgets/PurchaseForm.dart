import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_spinbox/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
import '../services/getInvoiceCount.dart';
import '../services/addPoints.dart';
import '../services/getPurchaseCount.dart';
import 'AddItemPurchase.dart';
import 'ReturnItemPurchase.dart';

// import '../services/addPurchase.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  // final Stream<QuerySnapshot> _brandStream =
  //     FirebaseFirestore.instance.collection('brands').snapshots();
  String? selectedBrand;
  int selectedQty = 1;
  String? purchaseType;
  int? purchaseCount;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

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
                ),
              ],
            ));
  }

  Future<void> beginPurchase() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Select Brand'),
              // title: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Text('Select brand'),
              //     ]),
              content: Container(
                width: double.minPositive,
                // width: 200,
                // height: 250,
                child: AddItemPurchase(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Done'),
                  child: const Text('Done'),
                ),
              ],
            ));
  }

  Future<void> beginReturn() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Select Return Type'),
              content: Container(
                width: double.minPositive,
                // width: 200,
                // height: 100,
                child: ReturnItemPurchase(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Done'),
                  child: const Text('Done'),
                ),
              ],
            ));
  }

  String depositType = '';
  Color color = Colors.transparent;
  String currentItem = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        child: Column(
          children: [
            Card(
              child: InkWell(
                onTap: () async {
                  if (await getInvoiceCount() != 0) {
                    invoicesAlert();
                  } else {
                    beginPurchase();
                  }
                },
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(
                    child: Text('Add Purchased Item', style: optionStyle),
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () async {
                  purchaseCount = await getPurchaseCount();
                  print(purchaseCount);
                  beginReturn();
                },
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(
                    child: Text('Return Purchased Item', style: optionStyle),
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
