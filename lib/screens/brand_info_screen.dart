import 'package:circulr/screens/widgets/BrandList.dart';
import 'package:flutter/material.dart';
import 'package:circulr/styles.dart';

class BrandInfoScreen extends StatelessWidget {
  const BrandInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: cBeige,
      appBar: AppBar(
        title: Text('Brand Info'),
        backgroundColor: primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 50),
              Image.network(
                '$brandLogoUrl',
                width: MediaQuery.of(context).size.width * 0.5,
                // width: 200,
              ),
              SizedBox(height: 35),
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
                            Text('$currentBrand', style: brandTitle),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: primary,
                                  size: 34,
                                ),
                                SizedBox(width: 5),
                                Text(
                                    'Location(s): ' +
                                        brandLocs.split(',').join('\n'),
                                    style: body),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(brandDesc, style: body),
                            // Text(
                            //     'Circulr was created to stop packaging waste at the source. Recycling was thought to be the answer to packaging for a long time. We now know however that recycling systems around the world are fundamentally flawed. Recycling will be an important tool on our path to zero waste, but it will not be enough in itself. The best way to deal with packaging is for it to be reused, which is why Circulr has decided to focus on making reusable packaging convenient and accessible.',
                            //     style: body),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
