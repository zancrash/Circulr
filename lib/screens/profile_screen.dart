import 'package:flutter/material.dart';
import 'widgets/user_invoices.dart';
import 'widgets/ProfileView.dart';
import 'package:circulr_app/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: Text(
                'Profile',
                style: appBarHeader,
              ),
              backgroundColor: primary,
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
                Container(
                  color: cBeige,
                  child: UserInvoices(),
                ),
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
