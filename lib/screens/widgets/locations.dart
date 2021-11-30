import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

Future<void> openMap(String address) async {
  MapsLauncher.launchQuery('$address');
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
            return Text('Error Occurred.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            // color: cBeige,
            child: ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  // color: cBeige,
                  child: ExpansionTile(
                    title: Text(data['name']),
                    subtitle: Text(data['address']),
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 15),
                          TextButton(
                            onPressed: () {
                              openMap(data['address'].toString());
                            },
                            child: Text('View in Maps'),
                            style: TextButton.styleFrom(
                                primary: cBeige, backgroundColor: primary),
                          ),
                        ],
                      )
                      // ListTile(
                      //   onTap: () {
                      //     openMap(data['address'].toString());
                      //   },
                      //   title: Text('View in Maps', style: smallTile),
                      // ),

                      // ListTile(title: Text('This is tile number 1')),
                    ],
                  ),

                  // child: ListTile(
                  //     title: Text(data['name']),
                  //     subtitle: Text(data['address']),
                  //     onTap: () async {
                  //       // DateTime returnDate = DateTime.now();
                  //       openMap(data['address'].toString());
                  //       print('Selected: ' +
                  //           data['name'] +
                  //           ' ' +
                  //           data['address'].toString());
                  //     }),
                );
              }).toList(),
            ),
          );
        });
  }
}
