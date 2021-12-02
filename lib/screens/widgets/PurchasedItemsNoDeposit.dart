import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import '../services/addReturned.dart';
import '../services/deleteItem.dart';
import '../services/addPoints.dart';
import 'package:circulr_app/styles.dart';

class PurchasedItemsNoDeposit extends StatefulWidget {
  const PurchasedItemsNoDeposit({Key? key}) : super(key: key);

  @override
  _PurchasedItemsNoDepositState createState() =>
      _PurchasedItemsNoDepositState();
}

class _PurchasedItemsNoDepositState extends State<PurchasedItemsNoDeposit> {
  var selectedLoc;
  late String selectedItem;
  late String itemId;
  late int itemQty;
  int returnQty = 1;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  void quickReturnDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('How many units are you returning from $selectedItem ?'),
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
              height: 120,
              child: Column(
                children: [
                  SpinBox(
                    min: 1,
                    max: itemQty.toDouble(),
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
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
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
                                  setState(() {
                                    selectedLoc = locValue;
                                  });
                                  print('Selected Location: $selectedLoc');
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
        }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel', style: TextStyle(color: cBlue)),
          ),
          TextButton(
            onPressed: () {
              addReturned(
                  selectedItem, returnQty); // add item to user's returned items
              deleteItem(itemId); // delete item from user's purchased items
              addPoints(3); // increment user's points by 3
              Navigator.pop(context, 'Complete Return');
              // Return successful dialog
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Return Complete'),
                  content: const Text('Item has been successfully returned!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Done');
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                      style: TextButton.styleFrom(
                          primary: cBeige, backgroundColor: cBlue),
                    ),
                  ],
                ),
              );

              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('Item Return Successful!'),
              // ));
              // Navigator.pop(context);
            },
            child: const Text('Complete Return'),
            style:
                TextButton.styleFrom(primary: cBeige, backgroundColor: primary),
          ),
        ],
      ),
    );
  }

  final Stream<QuerySnapshot> _itemStreamNoDeposit = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_purchased')
      .where('deposit type', isEqualTo: 'none')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _itemStreamNoDeposit,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error Occurred.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                  title: Text(data['brand']),
                  subtitle: Text(data['qty'].toString()),
                  onTap: () async {
                    // DateTime returnDate = DateTime.now();
                    selectedItem = data['brand'];
                    itemQty = data['qty'];
                    itemId = document.id;
                    Navigator.pop(context);
                    quickReturnDialog();
                  });
            }).toList(),
          );
        });
  }
}
