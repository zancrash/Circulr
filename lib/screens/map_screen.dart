import 'package:flutter/material.dart';
import 'widgets/locations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Centres'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          child: Locations(),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       Locations(),
      //     ],
      //   ),
      // ),
    );
  }
}