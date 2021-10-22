import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'widgets/locations.dart';
import 'widgets/MapView.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Centres'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(child: MapView()),
          ),
          SlidingUpPanel(
            panel: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  height: 70,
                  child: Center(
                    child: Text(
                      'Our Collection Locations:',
                      style: optionStyle,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                  child: Locations(),
                ),
              ],
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Container(
      //     // child: Locations(),
      //     child: MapView(),
      //   ),
      // ),
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
