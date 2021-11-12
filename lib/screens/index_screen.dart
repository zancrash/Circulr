// import 'package:circulr_app/screens/login_screen.dart';
// import 'package:circulr_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'map_screen.dart';
import 'returns_page.dart';
import 'about_screen.dart';
import 'PartneredBrands.dart';
import 'package:circulr_app/styles.dart';
import 'services/getUserEmail.dart';

// import 'services/getPoints.dart';
int _currentIndex = 0;

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

Future<void> getUserDoc() async {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  DocumentReference ref = _firestore.collection('users').doc(user?.uid);
  print('adding..');
  return ref.set({
    'email': user?.providerData[0].email,
    'name': user?.providerData[0].displayName,
    'points': 0,
  });
}

class _IndexScreenState extends State<IndexScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var userName = "";

  // create a new firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MapScreen(),
    ReturnsPage(),
    ProfileScreen(),
  ];

  // String? userEmail = getUserEmail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: cBeige,
      body: Center(
        child: _widgetOptions
            .elementAt(_currentIndex), // selected page appears here
      ),
      drawer: Drawer(
        child: Container(
          color: cBeige,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: primary,
                ),
                // child:getUserEmail(),
                child: Text(''),
              ),
              ListTile(
                  title: const Text('How it Works'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AboutScreen()));
                    print(user?.providerData[0].displayName);
                    print(user?.providerData[0].email);

                    print(user?.uid);
                    print(user?.providerData);
                    // isNewUser();
                    // print(isNewUser());
                    // getUserDoc();
                  }),
              ListTile(
                  title: const Text('Our Brands'),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const PartneredBrands()));
                  }),
              ListTile(
                  title: const Text('Referals'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text('FAQ'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              Container(
                width: 200,
                child: ElevatedButton(
                    child: Text('Sign Out'),
                    style: TextButton.styleFrom(
                        primary: cBeige, backgroundColor: cBlue),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        fixedColor: cBeige,
        backgroundColor: primary,
        // type: BottomNavigationBarType.shifting,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            // backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            title: Text('Collection Centres'),
            // backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            title: Text('Returns'),
            // backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile and Points'),
            // backgroundColor: Colors.red,
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
