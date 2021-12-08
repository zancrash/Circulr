import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';
import '../brand_info_screen.dart';

class BrandList extends StatefulWidget {
  const BrandList({Key? key}) : super(key: key);

  @override
  _BrandListState createState() => _BrandListState();
}

String? currentBrand;
String? brandLogoUrl;
String? brandItemType;
String brandDesc = '';
String brandLocs = '';

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
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          // leading: Icon(Icons.album),
                          leading: SizedBox(
                              // height: 75,
                              width: 75,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Image.network(
                                    data['logo'],
                                    width: 15,
                                  ))),
                          title: Text(
                            data['name'],
                            style: nameBlue,
                          ),
                          subtitle: Text('Item Type: ' + data['item_type']),
                          onTap: () {
                            currentBrand = data['name'];
                            brandLogoUrl = data['logo'];
                            brandItemType = data['item_type'];
                            brandDesc = data['desc'];
                            brandLocs = data['locations'];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const BrandInfoScreen()));
                          },
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: <Widget>[
                        //     TextButton(
                        //       child: Icon(Icons.info_outline),
                        //       onPressed: () {},
                        //       style: TextButton.styleFrom(
                        //           primary: cBeige, backgroundColor: cBlue),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),

                    // child: ExpansionTile(
                    //   title: Text(data['name']),
                    //   expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    //   expandedAlignment: Alignment.topLeft,
                    //   // subtitle: Text(data['address']),
                    //   children: <Widget>[
                    //     Row(
                    //       children: [
                    //         SizedBox(width: 15),
                    //         Text('Item Type: ' + data['item_type']),
                    //       ],
                    //     ),
                    //     SizedBox(height: 3),
                    //     Row(
                    //       children: [
                    //         SizedBox(width: 15),
                    //         Text('Deposit Type: ' + data['deposit type'])
                    //       ],
                    //     ),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
