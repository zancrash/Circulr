import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserPoints.dart';
import 'UserPurchased.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            child: UserPoints(),
          ),
        ),
        SlidingUpPanel(
          panel: Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                height: 70,
                child: Center(
                  child: Text(
                    'Your Purchased Items:',
                    style: optionStyle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                child: UserPurchased(),
              ),
            ],
          ),
        ),

        // SlidingUpPanel(panel: UserPurchased()),
      ],
    );
  }
}
