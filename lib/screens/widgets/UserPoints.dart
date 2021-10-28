import 'package:flutter/material.dart';
import '../services/getPoints.dart';

class UserPoints extends StatefulWidget {
  const UserPoints({Key? key}) : super(key: key);

  @override
  _UserPointsState createState() => _UserPointsState();
}

class _UserPointsState extends State<UserPoints> {
  int userPoints = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text(
              'Your Points:',
              style: optionStyle,
            ),
            GetPoints(),
          ],
        ),
      ),
    );
  }
}
