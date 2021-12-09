import 'package:circulr_app/screens/services/addPoints.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinbox/material.dart';
import 'PurchasedItems.dart';
import 'PurchasedItemsNoDeposit.dart';
import '../services/addGenericReturn.dart';
import 'PurchaseForm.dart';
import 'package:circulr_app/styles.dart';

class ReturnItemPurchase extends StatefulWidget {
  const ReturnItemPurchase({Key? key}) : super(key: key);

  @override
  _ReturnItemPurchaseState createState() => _ReturnItemPurchaseState();
}

class _ReturnItemPurchaseState extends State<ReturnItemPurchase> {
  bool requiresDeposit = false;
  var selectedLoc;
  String? selectedBrand;
  late String itemId;
  String purchaseType = '';
  late int itemQty;
  int purchaseQty = 1;

  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  Future<void> quickReturn() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              // title: const Text('Select Return Type'),
              titlePadding: EdgeInsets.fromLTRB(35, 10, 5, 0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Returning Item'),
                    CloseButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),

              content: Container(
                width: double.minPositive,
                child: PurchasedItems(),
              ),
            ));

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Dialog(
    //           child: Container(
    //         child: PurchasedItems(),
    //       ));
    //     });
  }

  Future<void> returnBrandedJar() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              // title: const Text('Select Return Type'),
              titlePadding: EdgeInsets.fromLTRB(35, 10, 5, 0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Returning Branded Jar',
                    ),
                    CloseButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),

              content: Container(
                width: double.minPositive,
                child: PurchasedItemsNoDeposit(),
              ),
            ));
  }

  Future<void> genericReturnSuccuess() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Generic Jar Return Added!'),
              content: Text(
                  'Generic Jar has been successfully marked returned. You have been awarded 2 points!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Done'),
                  child: const Text('Done'),
                  style: TextButton.styleFrom(
                      primary: cBeige, backgroundColor: cBlue),
                ),
              ],
            ));
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
                  child: const Text('Cancel', style: TextStyle(color: cBlue)),
                ),
                TextButton(
                    onPressed: () {
                      addGenericReturn(returnQty, selectedLoc);
                      addPoints(2);
                      Navigator.pop(context, 'Submit');
                      Navigator.pop(context);
                      genericReturnSuccuess();
                    },
                    child: const Text('Submit'),
                    style: TextButton.styleFrom(
                        primary: cBeige, backgroundColor: primary)),
              ],
            ));
  }

  // List<String>? returnTypes;

  List<String> returnTypes = ['Generic Jar', 'Branded Jar', 'Quick Return'];

  @override
  Widget build(BuildContext context) {
    (purchaseCount == 0)
        ? returnTypes.removeWhere((item) => item.toString() == 'Quick Return')
        : print('User has added purchases');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: returnTypes.length,
      itemBuilder: (BuildContext context, int index) {
        // (purchaseCount != 0) ? index = index - 1 : index = index;

        return ListTile(
          title: Text(returnTypes[index]),
          onTap: () {
            // print(PurchaseForm.purchaseCount);
            print(purchaseCount);
            if (returnTypes[index].toString() == 'Generic Jar') {
              genericReturnDialog();
            } else if (returnTypes[index].toString() == 'Branded Jar') {
              returnBrandedJar();
            } else {
              quickReturn();
            }
            print(returnTypes[index].toString());
            // Navigator.pop(context, returnTypes[index]);
          },
        );
      },
    );
  }
}
