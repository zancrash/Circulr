// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/register': (context) => LoginScreen(),
      },
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Circulr (Logged' + (user == null ? ' Out' : ' In') + ')'),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                    emailController.clear();
                    passwordController.clear();
                    setState(() {});
                  }),
              ElevatedButton(
                  child: Text('Sign In'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                    emailController.clear();
                    passwordController.clear();
                    setState(() {});
                  }),
              ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    setState(() {});
                  }),
              gUser == null ? Text('Logged out') : Text('Logged in.'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await _googleSignIn.signIn();
                    setState(() {});
                  },
                  child: Text('Sign in with Google')),
              ElevatedButton(
                  onPressed: () async {
                    await _googleSignIn.signOut();
                    setState(() {});
                  },
                  child: Text('Sign out from Google')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register Page Test'),
              ),
            ],
          ),
          // user == null
          //     ? ElevatedButton(
          //         child: Text('Logged Out'),
          //         onPressed: () async {
          //           setState(() {});
          //         },
          //       )
          //     : ElevatedButton(
          //         child: Text('Logged In'),
          //         onPressed: () async {
          //           setState(() {});
          //         },
          //       )
        ],
      ),
    );
  }
}



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Circulr',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: AuthenticationWrapper(),
//     );
//   }
// }

// class AuthenticationWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
