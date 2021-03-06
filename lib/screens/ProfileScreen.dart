import 'package:circulr/screens/widgets/ReturnedItems.dart';
import 'package:flutter/material.dart';
import 'widgets/UserInvoices.dart';
import 'widgets/ProfileView.dart';
import 'package:circulr/styles.dart';

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
          length: 3,
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
                  Tab(text: 'Returned'),
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
                  child: ReturnedItems(),
                ),
                Container(
                  color: cBeige,
                  child: UserInvoices(),
                ),
              ],
            ),
          )),
    );
  }
}
