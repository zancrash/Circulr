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
  // await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(user?.uid)
  //     .set({'email': 'test'});
}

class _IndexScreenState extends State<IndexScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var userName = "";

  // create a new firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // String? displayName = user?.providerData[0].displayName.toString();
  // await FirebaseFirestore.instance.collection('users').doc(newUser?.uid).set({'email': emailController.text});

  int _currentIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    // Text(
    //   'Index 0: Home',
    //   style: optionStyle,
    // ),
    HomeScreen(),
    MapScreen(),
    // Text(
    //   'Index 1: Collection Centres',
    //   style: optionStyle,
    // ),
    ReturnsPage(),
    // Text(
    //   'Index 2: Returns',
    //   style: optionStyle,
    // ),
    ProfileScreen(),
    // Text(
    //   'Index 3: Profile',
    //   style: optionStyle,
    // )
    // IndexScreen(),
    // RegisterScreen(),
    // LoginScreen(),
    // RegisterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Circulr Home'),
      //   backgroundColor: Colors.green,
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Header'),
            ),
            ListTile(
                title: const Text('How it Works'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const AboutScreen()));
                  print(user?.providerData[0].displayName);
                  print(user?.uid);
                  print(user?.providerData);
                  // isNewUser();
                  // print(isNewUser());
                  getUserDoc();
                }),
            ListTile(
                title: const Text('Our Brands'),
                onTap: () {
                  Navigator.pop(context);
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        fixedColor: Colors.green,
        // type: BottomNavigationBarType.shifting,
        type: BottomNavigationBarType.fixed,
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
