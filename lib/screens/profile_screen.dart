import 'package:flutter/material.dart';
import 'widgets/user_invoices.dart';
import 'widgets/ProfileView.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Profile'),
    //     backgroundColor: Colors.green,
    //   ),
    //   body: ProfileView(),
    // );
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.green,
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: 'Overview'),
                  Tab(text: 'Invoices'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Center(child: PurchaseForm()),
                Center(
                  child: ProfileView(),
                ),
                UserInvoices(),
              ],
            ),
          )),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('My Profile'),
    //     backgroundColor: Colors.green,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: <Widget>[
    //         UserInvoices(),
    //       ],
    //     ),
    //   ),
    // );
    // return ProfileView();
  }
}
