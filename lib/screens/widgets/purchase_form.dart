import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
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
    Object? data;
    return ref.add({
      'brand': selectedBrand,
      'qty': selectedQty,
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

  Future<void> updateUser() {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(user?.uid)
        // .update({'past_due': true})
        .update({'overdue_items': overdueCount})
        // .update({'overdue_items': FieldValue.increment(1)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // Function to increment user's overdue items count if an item is more than 30 days old
  int overdueCount = 0;
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
    overdueCount = itemCount;
    print('userPastDue executed.');
    // print('count: ' + overdueCount.toString());
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

    return overdueCount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _brandStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('No brands found.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
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
                      title: Text(data['name']),
                      subtitle: Text(data['item_type']),
                      onTap: () {
                        // print(data['name']);
                        selectedBrand = data['name'];
                        print('Selected: $selectedBrand');
                      });
                }).toList(),
              ),
              // Text('Selected: $selectedBrand'),
              // Text('Select QTY'),
              NumberPicker(
                value: _currentIntValue,
                minValue: 1,
                maxValue: 10,
                axis: Axis.horizontal,
                // step: 1,
                // haptics: true,
                // onChanged: (value) => setState(() => _currentIntValue = value),
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
                    userPastDue();
                    updateUser();
                    int overdues = await getOverdues();
                    if (overdues > 0) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Overdue Items'),
                                content: const Text(
                                    'You have items out that are past due, please pay the deposit to add more purchases'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
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
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // addPurchase();
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Purchase Added'),
                            content: const Text('Added'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Done'),
                                child: const Text('Done'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Add Purchase'))
            ],
          );
        });
  }
}
