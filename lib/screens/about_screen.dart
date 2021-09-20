import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text('How it Works'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Text(
            'About Page',
            style: optionStyle,
          ),
        ],
      ),
    );
  }
}
