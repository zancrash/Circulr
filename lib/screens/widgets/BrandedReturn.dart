import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import '../services/addReturned.dart';
import '../services/addBrandedReturned.dart';
import '../services/deleteItem.dart';
import '../services/addPoints.dart';
import 'package:circulr/styles.dart';

class BrandedReturn extends StatefulWidget {
  const BrandedReturn({Key? key}) : super(key: key);

  @override
  _BrandedReturnState createState() => _BrandedReturnState();
}

class _BrandedReturnState extends State<BrandedReturn> {
  var selectedLoc;
  late String selectedBrand;
  late String itemId;
  int itemQty = 1;
  int returnQty = 1;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  void brandedReturnDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('How many units are you returning from $selectedBrand ?'),
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
              height: 120,
              child: Column(
                children: [
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
                addBrandedReturned(selectedBrand, returnQty,
                    selectedLoc); // add item to user's returned items
                deleteItem(itemId); // delete item from user's purchased items
                addPoints(5 * returnQty); // increment user's points by 3
                Navigator.pop(context, 'Complete Return');
                // Return successful dialog
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Return Complete!'),
                    content: Text('You have been awarded ' +
                        (5 * returnQty).toString() +
                        ' points.'),
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

  final Stream<QuerySnapshot> _itemStreamNoDeposit = FirebaseFirestore.instance
      .collection('brands')
      // .doc(FirebaseAuth.instance.currentUser?.uid)
      // .collection('items_purchased')
      // .where('deposit type', isEqualTo: 'none')
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
                  title: Text(data['name']),
                  subtitle: Text('Item type: ' + data['item_type'].toString()),
                  onTap: () async {
                    // DateTime returnDate = DateTime.now();
                    selectedBrand = data['name'];
                    // itemQty = data['qty'];
                    itemId = document.id;
                    Navigator.pop(context);
                    brandedReturnDialog();
                  });
            }).toList(),
          );
        });
  }
}
