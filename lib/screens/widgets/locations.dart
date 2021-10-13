import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _locStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('No locations found.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
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
                      subtitle: Text(data['address']),
                      onTap: () async {
                        DateTime returnDate = DateTime.now();

                        print('Selected: ' +
                            data['name'] +
                            ' ' +
                            data['address'].toString());
                      });
                }).toList(),
              ),
            ],
          );
        });
  }
}
