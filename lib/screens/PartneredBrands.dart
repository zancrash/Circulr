import 'package:flutter/material.dart';
import 'package:circulr/styles.dart';
import 'widgets/BrandList.dart';

class PartneredBrands extends StatelessWidget {
  const PartneredBrands({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: cBeige,
      appBar: AppBar(
        title: Text('Our Partnered Brands'),
        backgroundColor: primary,
      ),
      body: BrandList(),
    );
  }
}
