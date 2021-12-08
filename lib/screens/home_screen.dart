import 'package:circulr_app/screens/widgets/BrandList.dart';
import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';
import 'HowItWorks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// const color = const Color(0xFF71C67A);

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: SingleChildScrollView(
        // reverse: true,
        // physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: cBeige,
              // height: MediaQuery.of(context).size.height * 0.48,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.045, 0, 0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 150,
                          child: Center(
                            child: Image.asset(
                              'assets/circulr_light_wide.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 50,
                          child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer()),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        'The Circulr app lets you earn rewards for reusing and returning items you\'ve purchased from our partners!',
                        style: homeInfo,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const HowItWorksScreen()));
                    },
                    child: Text('Learn More'),
                    style: TextButton.styleFrom(
                        primary: cBeige, backgroundColor: primary),
                  ),
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.025,
                    height: 25,
                  ),
                  Container(
                    color: secondary,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Center(
                        child: Text(
                          'Our Partnered Brands',
                          style: headerTwoWhite,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: primary,
              // height: 300,
              height: MediaQuery.of(context).size.height * 0.40,
              child: BrandList(),
            ),
          ],
        ),
      ),
    );
  }
}
