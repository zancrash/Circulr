import 'package:flutter/material.dart';
import 'package:circulr/styles.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('How It Works'),
          backgroundColor: primary,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 1,
          color: cBeige,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Purchase', style: headerTwo),
                                SizedBox(height: 10),
                                Text(
                                    'Purchase products from a Circulr partner brand and track them through our app to avoid upfront deposits, receive Circulr reward points, and keep track of the packaging you can return in your profile.',
                                    style: body),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // Container(
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                //         child: Container(
                //           width: MediaQuery.of(context).size.width * 0.8,
                //           child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text('Enjoy', style: headerTwo),
                //                 SizedBox(height: 10),
                //                 Text(
                //                     'You just bought a piece of packaging that will go back to the producer after you use it. That means you can enjoy it free of any guilt that you are adding to our waste problem.',
                //                     style: body),
                //               ]),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 25),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Return', style: headerTwo),
                                SizedBox(height: 10),
                                Text(
                                    'Return empty packaging from a Circulr brand to any one of our collection points and use our app to track the return. You will then get your deposit back, receive reward points, and have the item removed from your account.',
                                    style: body),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reward Points', style: headerTwo),
                              SizedBox(height: 10),
                              Text(
                                  'Reward points are gained whenever you track a purchase or return through Circulr. These points can be used with brands and retailers in the Circulr program. This is our way of saying thank you for making reuse possible.',
                                  style: body),
                              SizedBox(height: 10),
                              Text('1 Point', style: bodyHighlight),
                              SizedBox(height: 5),
                              Text('Track a purchased item'),
                              SizedBox(height: 10),
                              Text('2 points', style: bodyHighlight),
                              SizedBox(height: 5),
                              Text('Return a generic glass jar'),
                              SizedBox(height: 10),
                              Text('5 points', style: bodyHighlight),
                              SizedBox(height: 5),
                              Text('Return a brand partner\'s packaging '),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Deposits', style: headerTwo),
                                SizedBox(height: 10),
                                Text(
                                    'We have two types of deposits that brands can choose to use - normal and delayed.',
                                    style: body),
                                SizedBox(height: 10),
                                Text('Normal Deposits', style: bodyHighlight),
                                SizedBox(height: 5),
                                Text(
                                    'A normal deposit is paid upfront and returned to you when the packaging is returned. '),
                                SizedBox(height: 10),
                                Text('Delayed Deposits', style: bodyHighlight),
                                SizedBox(height: 5),
                                Text(
                                    'Delayed deposits allow you to avoid paying the deposit upfront. You are only invoiced if the product packaging is not returned within a set amount of time, just like a library book. You will get all of your deposit back when you eventually return the item. '),
                                SizedBox(height: 10),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ));
  }
}
