import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var selectedLoc;

class LocationsDropdown extends StatefulWidget {
  const LocationsDropdown({Key? key}) : super(key: key);

  @override
  LocationsDropdownState createState() => LocationsDropdownState();
}

class LocationsDropdownState extends State<LocationsDropdown> {
  // static var selectedLoc;
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          return DropdownButton<dynamic>(
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
          );
        }
      },
    );
  }
}
