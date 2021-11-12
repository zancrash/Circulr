import 'package:flutter/material.dart';
import '../services/getPoints.dart';
import 'package:circulr_app/styles.dart';

class UserPoints extends StatefulWidget {
  const UserPoints({Key? key}) : super(key: key);

  @override
  _UserPointsState createState() => _UserPointsState();
}

class _UserPointsState extends State<UserPoints> {
  int userPoints = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 280,
        child: Column(
          children: [
            Text(
              'Circulr Points Earned:',
              style: optionStyle,
            ),
            GetPoints(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('100 Points - 10% Discount to G&F', style: body),
                  SizedBox(height: 10),
                  Text('500 Points - \$10 coupon for PriZurv', style: body),
                  SizedBox(height: 10),
                  Text('10,000 Points - A romantic dinner date with Tyler',
                      style: body),
                  SizedBox(height: 20),
                  Text('To Redeem Points: email circulrshop@gmail.com.')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
