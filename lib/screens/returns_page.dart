import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({Key? key}) : super(key: key);

  @override
  _ReturnsPageState createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
            makePayment();
          },
          child: Text('Pay deposit')),
    ));
    // return Text(
    //   'Returns',
    //   style: optionStyle,
    // );
  }

  // move to services file in production...
  Future<void> makePayment() async {
    final url = Uri.parse(
        'https://us-central1-circulr-fb9b9.cloudfunctions.net/stripePayment');

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    paymentIntentData = json.decode(response.body);

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
            applePay: true,
            googlePay: true,
            // confirmPayment: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'CA',
            merchantDisplayName: 'Circulr'));
    setState(() {});

    displayPaymentSheet();
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deposit Successful')));
    } catch (e) {
      print(e);
    }
  }
}
