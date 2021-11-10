import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'widgets/locations.dart';
import 'widgets/MapView.dart';
import 'widgets/buildDragIcon.dart';

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
            // minHeight: AppBar().preferredSize.height,
            minHeight: 65,

            panel: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0),
                child: AppBar(
                  centerTitle: true,
                  // title: const Text('Our Collection Locations'),
                  title: Column(
                    children: [
                      buildDragIcon(),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Our Collection Locations'),
                      )
                    ],
                  ),
                ),
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
