import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBeige,
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        color: cBeige,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/circulr_light_wide.png',
                width: MediaQuery.of(context).size.width * 0.8,
                // width: 200,
              ),
              SizedBox(height: 30),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('The Problem', style: headerTwo),
                            SizedBox(height: 10),
                            Text(
                                'Circulr was created to stop packaging waste at the source. Recycling was thought to be the answer to packaging for a long time. We now know however that recycling systems around the world are fundamentally flawed. Recycling will be an important tool on our path to zero waste, but it will not be enough in itself. The best way to deal with packaging is for it to be reused, which is why Circulr has decided to focus on making reusable packaging convenient and accessible.',
                                style: body),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Circulr\'s Mission', style: headerTwo),
                            SizedBox(height: 10),
                            Text(
                                'Circulr’s mission is to create a global reuse infrastructure built by having communities and brands come together to reduce their waste.',
                                style: body),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Circulr\'s Vision', style: headerTwo),
                            SizedBox(height: 10),
                            Text('To End Waste.', style: body),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
