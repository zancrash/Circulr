import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';

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
                                    'Packaging from a circulr partner brand, and track it through our app to avoid upfront deposits, receive points toward coupons and discounts from our partnered brands, and keep track of your borrowed reusable packaging in your profile.',
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
                                    'Your used packaging from one of our partner brands to any one of our collection points. Use our app to track the return and all items will be taken off your account. You will then receive even more rewards and any deposits that were on the item back. Circulr can now get started on washing, sanitizing, and getting that packaging back into circulation.',
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
                                  'Are received whenever you track a purchase or return through Circulr you receive points toward brands and retailers in the Circulr program. This is our way of saying thank you for making reuse possible.',
                                  style: body),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  // SizedBox(width: 5),
                                  Text('- Tracking a purchased item = 1 point',
                                      style: body),
                                ],
                              ),
                              Row(
                                children: [
                                  // SizedBox(width: 5),
                                  Text(
                                      '- Returning a generic glass jar = 2 points',
                                      style: body),
                                ],
                              ),
                              Row(
                                children: [
                                  // SizedBox(width: 5),
                                  Text(
                                      '- Returning a brand partners packaging = 5 points',
                                      style: body),
                                ],
                              )
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
                                    'Are used to ensure we get as much packaging back as possible. We have two types of deposits - normal and reverse deposits.  A normal deposit is paid upfront and returned to you when the packaging is returned. Reverse deposits allow you to avoid paying the deposit upfront and are only charged to you if the packaging is not returned within a set amount of time. It is up to the brand which deposit format they prefer to use.',
                                    style: body),
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
