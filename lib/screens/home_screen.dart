import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
      child: Text(
        'Welcome to the Circulr Economy',
        style: optionStyle,
      ),
    );
  }
}
