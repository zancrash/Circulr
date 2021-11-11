import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';

class PartneredBrands extends StatefulWidget {
  const PartneredBrands({Key? key}) : super(key: key);

  @override
  _PartneredBrandsState createState() => _PartneredBrandsState();
}

class _PartneredBrandsState extends State<PartneredBrands> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Partnered Brands'),
        backgroundColor: primary,
      ),
    );
  }
}
