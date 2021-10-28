import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pay/pay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  var selectedLoc;
  final Stream<QuerySnapshot> _locStream =
      FirebaseFirestore.instance.collection('locations').snapshots();
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     GooglePayButton(
    //       paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
    //       paymentItems: _paymentItems,
    //       style: GooglePayButtonStyle.black,
    //       type: GooglePayButtonType.pay,
    //       margin: const EdgeInsets.only(top: 15.0),
    //       onPaymentResult: onGooglePayResult,
    //       loadingIndicator: const Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //   ],
    // );
    return Center(
      child: Text(
        'Welcome to the Circulr Economy',
        style: optionStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
