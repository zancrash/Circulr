import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

final Stream<QuerySnapshot> _faqstream =
    FirebaseFirestore.instance.collection('faq').snapshots();

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _faqstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('No Overdue items.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // print('loading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Container(
                child: Text('FAQ.', style: placeHolder),
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(data['question'], style: bodyHighlightBlue),
                ),
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(width: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(data['answer'], style: body),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              );
            }).toList(),
          );
        });
  }
}
