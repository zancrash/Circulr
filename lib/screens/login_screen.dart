import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circulr_app/styles.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
  }

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
  final nameController = TextEditingController();
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
      backgroundColor: cBeige,
      // appBar: AppBar(
      //   title: Text((user == null
      //       ? 'Enter Email and Password'
      //       : 'Logged into Circulr')),
      //   backgroundColor: primary,
      // ),

      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image(
              //   image: AssetImage('circulr_light_wide'),
              // ),
              Image.asset(
                'assets/circulr_light_wide.png',
                width: MediaQuery.of(context).size.width * 0.8,
                // width: 200,
              ),
              SizedBox(height: 15),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        titlePadding: EdgeInsets.fromLTRB(35, 10, 5, 0),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in With Email',
                              ),
                              CloseButton(
                                onPressed: () {
                                  emailController.clear();
                                  passwordController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ]),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Container(
                              height: 220,
                              child: Column(
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
                                  SizedBox(height: 25),
                                  ElevatedButton(
                                      child: Text('Sign In'),
                                      style: ElevatedButton.styleFrom(
                                        primary: primary,
                                        // backgroundColor: primary,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text);

                                        emailController.clear();
                                        passwordController.clear();
                                        setState(() {});
                                      }),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          titlePadding:
                                              EdgeInsets.fromLTRB(35, 10, 5, 0),
                                          title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Register With Email',
                                                ),
                                                CloseButton(
                                                  onPressed: () {
                                                    emailController.clear();
                                                    passwordController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ]),
                                          content: StatefulBuilder(
                                              builder: (context, setState) {
                                            return Container(
                                                height: 220,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          nameController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Name',
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Email',
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          passwordController,
                                                      obscureText: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Password',
                                                      ),
                                                    ),
                                                    SizedBox(height: 25),
                                                    ElevatedButton(
                                                        child: Text('Register'),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: primary,
                                                          // backgroundColor: primary,
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          UserCredential
                                                              result =
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .createUserWithEmailAndPassword(
                                                                      email: emailController
                                                                          .text,
                                                                      password:
                                                                          passwordController
                                                                              .text);
                                                          User? newUser =
                                                              result.user;
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(newUser?.uid)
                                                              .set({
                                                            'name':
                                                                nameController
                                                                    .text,
                                                            'email':
                                                                emailController
                                                                    .text,
                                                            'points': 0
                                                          });
                                                          await FirebaseAuth
                                                              .instance
                                                              .signInWithEmailAndPassword(
                                                                  email:
                                                                      emailController
                                                                          .text,
                                                                  password:
                                                                      passwordController
                                                                          .text);
                                                          emailController
                                                              .clear();
                                                          passwordController
                                                              .clear();
                                                          setState(() {});
                                                        }),
                                                  ],
                                                ));
                                          }),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      primary: cBlack,
                                      // backgroundColor: primary,
                                    ),
                                    child: Text('Don\'t have an account?'),
                                  ),
                                ],
                              ));
                        }),
                      ),
                    );
                  },
                  child: Text('Continue With Email'),
                  style: TextButton.styleFrom(
                    primary: cBeige,
                    backgroundColor: primary,
                  )),
              SizedBox(height: 15),
              Text('Or'),
              SizedBox(height: 15),
              SignInButton(Buttons.Google, text: 'Continue with Google',
                  onPressed: () {
                signInWithGoogle();
              }),
              SignInButton(Buttons.Apple, text: 'Continue with Apple',
                  onPressed: () {
                signInWithApple();
              }),
              // (Platform.isIOS)
              //     ? SignInButton(Buttons.Apple, text: 'Continue with Apple',
              //         onPressed: () {
              //         signInWithApple();
              //       })
              //     : Container(
              //         child: Text(''),
              //       ),
              // Text('Get Rewarded for Reuse', style: tagline),
              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     // ElevatedButton(
              //     //     child: Text('Sign Out'),
              //     //     onPressed: () async {
              //     //       await FirebaseAuth.instance.signOut();
              //     //       setState(() {});
              //     //     }),
              //   ],
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () async {
              //         final newUser = await Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => RegisterScreen()));
              //         setState(() {});
              //         print('register pressed');
              //       },
              //       child: Text('Register'),
              //       style: ElevatedButton.styleFrom(
              //         primary: Colors.white,
              //         onPrimary: Colors.black,
              //         shadowColor: Colors.white,
              //       ),
              //     ),
              //     // gUser == null
              //     //     ? Text('Logged out from Google.')
              //     //     : Text('Logged in with Google.'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
