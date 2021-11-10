import 'package:flutter/material.dart';
import 'UserPoints.dart';
import 'UserPurchased.dart';
import 'ReverseDepositItems.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'buildDragIcon.dart';

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
          // minHeight: AppBar().preferredSize.height,
          minHeight: 65,
          // minHeight: PreferredSize().preferredSize.height,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          panel: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120.0),
                child: AppBar(
                  centerTitle: true,
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Reverse Deposit Items'),
                      Tab(text: 'Other Items'),
                    ],
                  ),
                  title: Column(
                    children: [
                      buildDragIcon(),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Your Purchased Items'),
                      )
                    ],
                  ),
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
}
