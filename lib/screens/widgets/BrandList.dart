import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';

class BrandList extends StatefulWidget {
  const BrandList({Key? key}) : super(key: key);

  @override
  _BrandListState createState() => _BrandListState();
}

final Stream<QuerySnapshot> _brandStream =
    FirebaseFirestore.instance.collection('brands').snapshots();

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _brandStream,
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
                  child: ListTile(
                      title: Text(data['name']),
                      subtitle: Text('Item Type: ' + data['item_type']),
                      onTap: () async {
                        // DateTime returnDate = DateTime.now();

                        // print('Selected: ' +
                        //     data['name'] +
                        //     ' ' +
                        //     data['address'].toString());
                      }),
                );
              }).toList(),
            ),
          );
        });
  }
}
