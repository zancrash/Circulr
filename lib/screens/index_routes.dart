// import 'package:circulr_app/screens/login_screen.dart';
// import 'package:circulr_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'map_screen.dart';
import 'returns_page.dart';
import 'about_screen.dart';

import 'drawer_item.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MapScreen(),
    ReturnsPage(),
    ProfileScreen(),
  ];

  int _drawerSelection = 0;

  final drawerItems = [
    DrawerItem(
      "How it works",
    ),
    DrawerItem(
      "Our Brands",
    ),
    DrawerItem(
      "Referals",
    ),
    DrawerItem(
      "FAQ",
    ),
  ];

  _getDrawerItem(int pos) {
    switch (pos) {
      case 1:
        return AboutScreen();
      case 2:
        return AboutScreen();
      case 3:
        return AboutScreen();
      case 4:
        return AboutScreen();
      default:
        return null;
    }
  }

  _onDrawerItemSelect(int drawerIndex) {
    setState(() {
      _drawerSelection = drawerIndex;
      _getDrawerItem(_drawerSelection);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _getDrawerItem(_drawerSelection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        title: Text(
          d.title,
        ),
        selected: i == _drawerSelection,
        onTap: () => _onDrawerItemSelect(i),
      ));
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Circulr Home'),
      //   backgroundColor: Colors.green,
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),

      drawer: Drawer(
        child: Column(
          // padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Header'),
            ),
            Column(
              children: drawerOptions,
            ),

            // ListTile(
            //     title: const Text('How it Works'),
            //     onTap: () {
            //       Navigator.pushNamed(context, '/about');
            //       print('navigate to about screen.');
            //       Navigator.pop(context);
            //     }),
            // ListTile(
            //     title: const Text('Our Brands'),
            //     onTap: () {
            //       Navigator.pop(context);
            //     }),
            // ListTile(
            //     title: const Text('Referals'),
            //     onTap: () {
            //       Navigator.pop(context);
            //     }),
            // ListTile(
            //     title: const Text('FAQ'),
            //     onTap: () {
            //       Navigator.pop(context);
            //     }),
            ElevatedButton(
                child: Text('Sign Out'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                }),
          ],
        ),
      ),
      // body: (Column(
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         _widgetOptions.elementAt(_currentIndex),
      //         ElevatedButton(
      //             child: Text('Sign Out'),
      //             onPressed: () async {
      //               await FirebaseAuth.instance.signOut();
      //               // setState(() {});
      //             }),
      //       ],
      //     ),
      //   ],
      // )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            title: Text('Collection Centres'),
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            title: Text('Returns'),
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile and Points'),
            backgroundColor: Colors.red,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// class IndexScreen extends StatelessWidget {
//   const IndexScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//   }
// }
