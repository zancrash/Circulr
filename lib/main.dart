import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/index_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  // runApp(MaterialApp(
  //     initialRoute: '/',
  //     routes: {
  //       '/register': (context) => RegisterScreen(),
  //       '/login': (context) => LoginScreen(),
  //     },
  //     home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// void registerScreen(BuildContext context) async {
//   final newUser = await Navigator.pushNamed(context, '/register');
// }

class LandingLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // void getPage() {

  // }

  Widget _getLandingPage(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          // GoogleSignInAccount? gUser = _googleSignIn.currentUser;
          if (snapshot.hasData) {
            //List? provData = snapshot.data!.providerData;
            // if ( snapshot.data!.providerData.length == 1) {
            //   return snapshot.data!.emailVerified ? IndexScreen() : LoginScreen();
            // }
            return IndexScreen();
          }
          return LoginScreen();
        });
  }
}

class _MyAppState extends State<MyApp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // init google sign in
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    GoogleSignInAccount? gUser = _googleSignIn.currentUser;

    return (MaterialApp(
      home: LandingLogic()._getLandingPage(context),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/about': (context) => AboutScreen(),
      },
    ));
  }
}
