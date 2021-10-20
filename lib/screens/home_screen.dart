import 'package:circulr_app/screens/widgets/locationsDropdown.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  var selectedLoc;
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     padding: EdgeInsets.all(23),
    //     child: ListView.separated(
    //         itemBuilder: (context, index) {
    //           Icon icon;
    //           Text text;
    //           switch (index) {
    //             case 0:
    //               icon = Icon(Icons.add_circle, color: Colors.green);
    //               text = Text('Add Card');
    //               break;
    //             case 1:
    //               icon = Icon(Icons.credit_card, color: Colors.green);
    //               text = Text('Choose Card');
    //               break;
    //           }
    //           return InkWell(
    //             onTap: () {
    //               onItemPress(context, index);
    //             },
    //             child: ListTile(
    //               title: text,
    //               leading: icon,
    //             ),
    //           );
    //         },
    //         separatorBuilder: (context, index) => Divider(color: Colors.green,),
    //         itemCount: 2)
    //         );
    return Center(
      child: Container(
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
              return DropdownButton<dynamic>(
                items: locItems,
                onChanged: (locValue) async {
                  // final snackBar = SnackBar(
                  //   content: Text('Selected Location: $locValue'),
                  // );
                  // int overdueCount = await getOverdues();
                  // print(overdueCount);
                  setState(() {
                    selectedLoc = locValue;
                  });
                  print('Selected Location: $selectedLoc');
                  // ScaffoldMessenger.showSnackBar(snackBar)
                },
                value: selectedLoc,
                isExpanded: false,
                hint: new Text('Select Location'),
              );
            }
          },
        ),
      ),

      // child: LocationsDropdown(),
      // child: Text(
      //   'Welcome to the Circulr Economy',
      //   style: optionStyle,
      // ),
    );
  }
}
