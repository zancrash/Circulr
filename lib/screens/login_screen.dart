import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Google Sign in function
Future<UserCredential> signInWithGoogle() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // added code
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);

  final User? user = authResult.user;

  // check if user is new
  if (authResult.additionalUserInfo!.isNewUser) {
    print(user?.providerData[0].uid);
    getUserDoc();
  } else {
    print('not a new user');
    getUserDoc();
  }

  // getUserDoc();

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> signInWithApple() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // added code
  final UserCredential authResult =
      await _auth.signInWithCredential(oauthCredential);

  final User? user = authResult.user;

  // check if user is new
  if (authResult.additionalUserInfo!.isNewUser) {
    print(user?.providerData[0].uid);
    getUserDoc();
  } else {
    print('not a new user');
    getUserDoc();
  }
  // end of added code

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
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

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // init google sign in
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    const googleRed = Color(0xFFde5246);
    // GoogleSignInAccount? gUser = _googleSignIn.currentUser;

    // if (user == null) {
    //   Navigator.pushNamed(context, '/login');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text((user == null
            ? 'Enter Email and Password'
            : 'Logged into Circulr')),
        backgroundColor: Colors.green,
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
                  child: Text('Sign In'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                    emailController.clear();
                    passwordController.clear();
                    setState(() {});
                  }),
              // ElevatedButton(
              //     child: Text('Sign Out'),
              //     onPressed: () async {
              //       await FirebaseAuth.instance.signOut();
              //       setState(() {});
              //     }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: Text('Sign in with Google')),

              // ElevatedButton(
              //     onPressed: () async {
              //       await _googleSignIn.signIn();
              //       setState(() {});
              //       // print('user: \n');
              //       // print(gUser);
              //     },
              //     child: Text('Sign in with Google')),

              // ElevatedButton(
              //     onPressed: () async {
              //       await _googleSignIn.signOut();
              //       setState(() {});
              //     },
              //     child: Text('Sign out from Google')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: signInWithApple,
                child: Text('Sign in with Apple'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                  setState(() {});
                  print('register pressed');
                },
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shadowColor: Colors.white,
                ),
              ),
              // gUser == null
              //     ? Text('Logged out from Google.')
              //     : Text('Logged in with Google.'),
            ],
          ),
        ],
      ),
    );
  }
}
