import 'package:flutter/material.dart';
import 'package:circulr/styles.dart';
import 'widgets/Locations.dart';

class CollectionLocations extends StatelessWidget {
  const CollectionLocations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: cBeige,
      appBar: AppBar(
        title: Text('Our Collection Locations'),
        backgroundColor: primary,
      ),
      body: Locations(),
    );
  }
}
