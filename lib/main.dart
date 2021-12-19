import 'package:circulr/screens/PartneredBrands.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'screens/RegisterScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/IndexScreen.dart';
import 'screens/AboutScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51K89hCBLC3gTjIq5j2dUJbKVPlKyphoTGM6OgfqfQU5ucn5SiC1CiA4XMs8Sjm2WmXyWlgU1KiVAy8TUX74UF99q00iyUd11Uu';
  Stripe.merchantIdentifier = 'circulr';
  await Stripe.instance.applySettings();

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

class LandingLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/about': (context) => AboutScreen(),
        '/brands': (context) => PartneredBrands(),
      },
    ));
  }
}
