import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import '../services/addReturned.dart';
import '../services/deleteItem.dart';
import '../services/addPoints.dart';
import 'package:circulr/styles.dart';

class PurchasedItems extends StatefulWidget {
  const PurchasedItems({Key? key}) : super(key: key);

  @override
  _PurchasedItemsState createState() => _PurchasedItemsState();
}

class _PurchasedItemsState extends State<PurchasedItems> {
  var selectedLoc;
  late String selectedItem;
  late String itemId;
  late int itemQty;
  int returnQty = 1;
  int rewardPoints = 1;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  Future<void> locationVoidDialogue() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Please select return location'),
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
                      rewardPoints = value.toInt() * 5;
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
              if (selectedLoc == null) {
                // locationVoidDialogue();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text('Please select return location'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                              style: TextButton.styleFrom(
                                  primary: cBeige, backgroundColor: cBlue),
                            ),
                          ],
                        ));

                print('location void');
              } else {
                addReturned(selectedItem, returnQty,
                    selectedLoc); // add item to user's returned items
                deleteItem(itemId); // delete item from user's purchased items

                // increment user's points depending on how many items they return
                addPoints(returnQty * 5);
                Navigator.pop(context, 'Complete Return');
                // Return successful dialog
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Return Complete'),
                    content: Text(
                        'Item has been successfully returned! You\'ve been awarded ' +
                            (returnQty * 5).toString() +
                            ' point(s)'),
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
              }

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

  final Stream<QuerySnapshot> _itemStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items_purchased')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _itemStream,
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
                  subtitle: Text('QTY: ' + data['qty'].toString()),
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
