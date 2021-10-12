import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'widgets/purchase_form.dart';

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
    // return PurchaseForm();
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
        backgroundColor: Colors.green,
      ),
      body: PurchaseForm(),
    );

    // return Text(
    //   'Collection Centres',
    //   style: optionStyle,
    // );
  }
}
