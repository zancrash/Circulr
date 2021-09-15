import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // init google sign in
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    GoogleSignInAccount? gUser = _googleSignIn.currentUser;

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
              ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    setState(() {});
                  }),
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
                },
                child: Text('Register'),
              ),
              gUser == null
                  ? Text('Logged out from Google.')
                  : Text('Logged in with Google.'),
            ],
          ),
        ],
      ),
    );
  }
}
