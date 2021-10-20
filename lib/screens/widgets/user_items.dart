import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import '../services/addGenericReturn.dart';
import '../services/checkInvoiceExists.dart';
import '../services/addInvoice.dart';
import 'purchasedItems.dart';

class UserItems extends StatefulWidget {
  const UserItems({Key? key}) : super(key: key);

  @override
  _UserItemsState createState() => _UserItemsState();
}

class _UserItemsState extends State<UserItems> {
  // User? user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _itemStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_purchased')
      .snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void>? deleteItem() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var collection = _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased');
    var snapshot =
        await collection.where('date', isEqualTo: itemPurchased).get();
    await snapshot.docs.first.reference.delete();
  }

  String? selectedBrand;

  int? daysBetween(DateTime? from, DateTime to) {
    from = DateTime(from!.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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

  // Update user overdue items count:
  int overdueCount = 0; // varialbe to store number of overdue items
  void userPastDue() async {
    User? user = FirebaseAuth.instance.currentUser;
    DateTime x = DateTime.now().subtract(Duration(days: 30));

    int itemCount = 0;

    // query firestore for user items more than 30 days old
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('items_purchased')
        .where('date', isLessThanOrEqualTo: x)
        .get();
    result.docs.forEach((res) {
      addInvoice(
          res.data()['brand'], res.data()['qty'], res.data()['date'].toDate());
      itemCount +=
          1; // for each item more than 30 days old, increment item count variable
    });
    print(itemCount);
    print('userPastDue executed.');
    overdueCount = itemCount;
  }

  // Run function to decrement user's overdue items count
  Future<void> userReturnLate() async {
    User? user = FirebaseAuth.instance.currentUser;
    DateTime x = DateTime.now().subtract(Duration(days: 30));

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .doc(user?.uid)
        .update({'overdue_items': FieldValue.increment(-1)});
  }

  // function to get user's overdue count
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

  Future<void> quickReturn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            child: PurchasedItems(),
          )
              //     child: Column(
              //   children: [
              //     Text('Select Item'),
              //     Center(
              //         child: Container(
              //       child: PurchasedItems(),
              //     )),
              //   ],
              // )),
              );
        });
  }

  Future<void> genericReturnDialog() async {
    late int returnQty;
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Return Details'),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                      height: 120,
                      child: Column(
                        children: [
                          Text('How many units are you returning?'),
                          SpinBox(
                            min: 1,
                            max: 100,
                            value: 1,
                            onChanged: (value) {
                              returnQty = value.toInt();
                              print(value);
                            },
                          ),
                          // LocationsDropdown(),
                          Container(
                            height: 50,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _locStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('Error loading location data');
                                } else {
                                  List<DropdownMenuItem> locItems = [];
                                  for (int i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[i];
                                    locItems.add(
                                      DropdownMenuItem(
                                        child: Text(
                                          snap['name'],
                                        ),
                                        value: snap['name'],
                                      ),
                                    );
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      DropdownButton<dynamic>(
                                        items: locItems,
                                        onChanged: (locValue) async {
                                          print(overdueCount);
                                          setState(() {
                                            selectedLoc = locValue;
                                          });
                                          print(
                                              'Selected Location: $selectedLoc');
                                        },
                                        value: selectedLoc,
                                        isExpanded: false,
                                        hint: new Text('Select Location'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ));
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                      addGenericReturn(returnQty, selectedLoc);
                      Navigator.pop(context, 'Submit');
                    },
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    )),
              ],
            ));
  }

  DateTime? itemPurchased;
  double _currentSliderValue = 1;

  int overdues = 0;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 15), (Timer t) => userPastDue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // void testFunc() async {
  //   setState(() {});
  //   // print('test func');
  // }

  static const TextStyle titleStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  var selectedLoc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text(
              'Return a Purchased Item:',
              style: titleStyle,
            ),
            ElevatedButton(
              onPressed: () {
                genericReturnDialog();
              },
              child: Text('Return Generic Jar'),
            ),
            ElevatedButton(
              onPressed: () {
                quickReturn();
              },
              child: Text('Quick Return'),
            ),
          ],
        ),
      ),
    );
    // return Column(children: [
    //   Center(
    //       child: Container(
    //           height: 100,
    //           child: Text(
    //             'Return a Purchased Item:',
    //             style: titleStyle,
    //           ))),
    //   Container(
    //     child: Column(
    //       children: [
    //         ElevatedButton(
    //           onPressed: () {
    //             genericReturnDialog();
    //           },
    //           child: Text('Return Generic Jar'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             quickReturn();
    //           },
    //           child: Text('Quick Return'),
    //         ),
    //       ],
    //     ),
    //   ),
    // ]);
  }
}
