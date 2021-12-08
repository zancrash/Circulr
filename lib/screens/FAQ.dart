import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQ'),
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
                                Text(
                                    'Can I return packaging from brands you don’t work with?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'Yes! We accept glass jars from any brand. We clean this packaging and then sell it back to interested small businesses.',
                                    style: body),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                Text(
                                    'How do delayed deposits differ from "normal" deposits?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'The problem with “normal” deposits is that they keep your money in limbo. This means that living green becomes cost-prohibitive. We are working with brands to test out reverse deposits. Through these deposits, you don’t have to pay anything! The only situation where you pay is if you don’t return the packaging within a certain amount of time. If you return it after you’ve already been charged, then we will refund you the full deposit amount.',
                                    style: body),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                Text(
                                  'Is reuse safe and sanitary?',
                                  style: faq,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    'We know during this pandemic many people are worried about sanitation in reuse. Though scientists have said reuse is safe during COVID, Circulr takes special care to ensure our process is sanitary and safe. All of the packaging returned to our bins is washed and sanitized in order to ensure any germs or bacteria are removed. Once the containers are clean they are packaged and sealed before being shipped back to the supplier for reuse.',
                                    style: body),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
                                Text('What can I use Circulr Points for?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'Reuse shouldn\'t be a chore. For this reason, we decided to incentivize customer reuse by offering rewards. Points are given to users who take certain actions. For a full description of our rewards program click here.',
                                    style: body),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
                                Text(
                                    'My packaging is damaged/ cracked, can I still return it?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'Unfortunately, we’re only able to accept packaging that is in the same condition it was in when you purchased it. If there are any cracks, dents, or other damage, we kindly ask that you recycle the package.',
                                    style: body),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
                                Text(
                                    'Can I return the packaging even if I did not track it when I purchased it?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'Yes! We accept all of the packaging listed on our what we collect page, regardless of when it was purchased, or if it was tracked.',
                                    style: body),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
                                Text(
                                    'Do I have to wash my containers before returning them?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'No, but we do ask that you rinse out any remaining food from the container. A simple rinse makes the washing process much easier!',
                                    style: body),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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
                                Text(
                                    'Do I have to return the packaging to the same location I bought it?',
                                    style: faq),
                                SizedBox(height: 10),
                                Text(
                                    'No, you can return the packaging to any of the collection sites in our network.',
                                    style: body),
                              ]),
                        ),
                      )
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
