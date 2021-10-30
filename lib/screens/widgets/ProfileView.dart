import 'package:flutter/material.dart';
import 'UserPoints.dart';
import 'UserPurchased.dart';
import 'ReverseDepositItems.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  final panelController = PanelController();

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
          minHeight: AppBar().preferredSize.height,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          panel: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(text: 'Reverse Deposit Items'),
                    Tab(text: 'Other Items'),
                  ],
                ),
                title: Column(
                  children: [
                    // buildDragIcon(),
                    Text('Your Purchased Items'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  ReverseDepositItems(),
                  UserPurchased(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 40,
        height: 8,
      );
}
