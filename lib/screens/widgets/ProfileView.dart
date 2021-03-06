import 'package:flutter/material.dart';
import 'UserPoints.dart';
import 'UserPurchased.dart';
import 'ReverseDepositItems.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'BuildDragIcon.dart';
import 'package:circulr/styles.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            color: cBeige,
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
                  backgroundColor: cBlue,
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Delayed Deposit Items'),
                      Tab(text: 'Other Items'),
                    ],
                  ),
                  title: Column(
                    children: [
                      BuildDragIcon(),
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
