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
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
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
            minHeight: AppBar().preferredSize.height,
            panel: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Our Collection Locations'),
              ),
              body: Locations(),
            ),
            borderRadius: radius,
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
