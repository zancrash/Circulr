import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';
import 'PartneredBrands.dart';
import 'CollectionLocations.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          'Home',
          style: appBarHeader,
        ),
        backgroundColor: primary,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: cBeige,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Welcome Banner
              Container(
                color: primary,
                width: MediaQuery.of(context).size.height * 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.height * 0.02,
                      0,
                      MediaQuery.of(context).size.height * 0.02),
                  child: Text(
                    'Welcome to the \n Circulr Economy',
                    style: header,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Process Section
              Container(
                color: cBeige,
                // width: MediaQuery.of(context).size.width * 1,
                // height: MediaQuery.of(context).size.height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0.03,
                          0,
                          MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            'https://cdn.shopify.com/s/files/1/0263/6526/3919/files/store-scanner-for-checkout_540x.jpg?v=1618515168'))),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Purchase',
                                      style: headerThree,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Circulr will allow you to track any item purchased from one of our amazing partnered businesses.',
                                      style: body,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Enjoy',
                                      style: headerThree,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      'Not a super hard step, but you should still appreciate what you bought, and your efforts to create a better world through reuse!',
                                      style: body,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            'https://cdn.shopify.com/s/files/1/0263/6526/3919/files/breakfast-from-above_540x.jpg?v=1619036498'))),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            'https://cdn.shopify.com/s/files/1/0263/6526/3919/files/shipping-boxes-in-front-of-red-brick_540x.jpg?v=1618515405'))),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Rinse and Return',
                                      style: headerThree,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                        'Once you\'ve enjoyed everything drop it off at one of our collection sites.',
                                        style: body),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.030),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const PartneredBrands()));
                                },
                                child: Text('Partnered Brands'),
                                style: TextButton.styleFrom(
                                    primary: cBeige, backgroundColor: primary),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const CollectionLocations()));
                                },
                                child: Text('Our Collection Sites'),
                                style: TextButton.styleFrom(
                                    primary: cBeige, backgroundColor: cBlue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Center(
              //   heightFactor: 1.5,
              //   child:
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
