import 'package:circulr_app/screens/widgets/purchase_form.dart';
import 'package:circulr_app/screens/widgets/user_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({Key? key}) : super(key: key);

  @override
  _ReturnsPageState createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  // Map<String, dynamic>? paymentIntentData;
  int x = 0;
  int overdues = 0;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: Center(
    //   child: ElevatedButton(
    //       onPressed: () {
    //         makePayment();
    //       },
    //       child: Text('Pay deposit')),
    // ));
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Purchase'),
              backgroundColor: Colors.green,
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: 'Track Purchases'),
                  Tab(text: 'Track Returns'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Center(child: PurchaseForm()),
                Center(
                  child: (overdues != 0)
                      ? Text(
                          'Please pay outstanding invoices to add more purchases.')
                      : PurchaseForm(),
                ),
                Center(child: UserItems()),
              ],
            ),
          )),
    );

    // return Text(
    //   'Returns',
    //   style: optionStyle,
    // );
  }

  // @override
  // afterFirstLayout(BuildContext context) async {
  //   // getOverdues();
  //   print('test');
  //   int overdues = await getOverdues();
  // }

  // Get user's overdue items count
  Future<int> getOverdues() async {
    User? user = FirebaseAuth.instance.currentUser;
    int overdueCount = 0;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    docRef.get().then((snapshot) {
      overdueCount = snapshot['overdue_items'];
    });
    print('overdue count: ' + overdueCount.toString());

    return overdueCount;
  }

  // move to services file in production...
  // Future<void> makePayment() async {
  //   final url = Uri.parse(
  //       'https://us-central1-circulr-fb9b9.cloudfunctions.net/stripePayment');

  //   final response =
  //       await http.get(url, headers: {'Content-Type': 'application/json'});

  //   paymentIntentData = json.decode(response.body);

  //   await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
  //           applePay: true,
  //           googlePay: true,
  //           // confirmPayment: true,
  //           style: ThemeMode.dark,
  //           merchantCountryCode: 'CA',
  //           merchantDisplayName: 'Circulr'));
  //   setState(() {});

  //   displayPaymentSheet();
  // }

  // Future<void> displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     setState(() {
  //       paymentIntentData = null;
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Deposit Successful')));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
