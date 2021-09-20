import 'package:flutter/material.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({Key? key}) : super(key: key);

  @override
  _ReturnsPageState createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Returns',
      style: optionStyle,
    );
  }
}
