import 'package:flutter/material.dart';
import '../services/getPoints.dart';
import 'package:circulr/styles.dart';

class UserPoints extends StatefulWidget {
  const UserPoints({Key? key}) : super(key: key);

  @override
  _UserPointsState createState() => _UserPointsState();
}

class _UserPointsState extends State<UserPoints> {
  int userPoints = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 280,
        child: Column(
          children: [
            Text(
              'Circulr Points Earned:',
              style: optionStyle,
            ),
            GetPoints(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Points and Rewards'),
                          content: Container(
                            height: 370,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Points', style: headerThree),
                                  SizedBox(height: 5),

                                  Text('\n1 Point', style: bodyBlue),
                                  SizedBox(height: 5),
                                  Text('Track a purchased item'),
                                  SizedBox(height: 10),
                                  Text('2 points', style: bodyBlue),
                                  SizedBox(height: 5),
                                  Text('Return a generic glass jar'),
                                  SizedBox(height: 10),
                                  Text('5 points', style: bodyBlue),
                                  SizedBox(height: 5),
                                  Text('Return a brand partner\'s packaging '),
                                  // Text(
                                  //     '\n1 point for each purchased item \n2 points for each returned generic jar \n3 points for each returned branded item'),
                                  Text('\nRewards', style: headerThree),
                                  Text('\n100 Points - 10% Discount to G&F',
                                      style: body),
                                  SizedBox(height: 10),
                                  Text('500 Points - \$10 coupon for PriZurv',
                                      style: body),
                                  SizedBox(height: 20),
                                  Text('To Redeem Points, email:'),
                                  SizedBox(height: 5),
                                  Text('circulrshop@gmail.com',
                                      style: bodyBlue),
                                ],
                              ),
                            ),
                          ),
                          // content: const Text(
                          //     'Item has been successfully returned!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Done');
                              },
                              child: const Text('Done'),
                              style: TextButton.styleFrom(
                                  primary: cBeige, backgroundColor: cBlue),
                            ),
                          ],
                        ),
                      );
                    },
                    label: Text('How Reward Points Work'),
                    style: TextButton.styleFrom(
                        primary: cBeige, backgroundColor: secondary),
                    icon: Icon(
                      Icons.loyalty,
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('How Reward Points Work'),
                  //   style: TextButton.styleFrom(
                  //       primary: cBeige, backgroundColor: secondary),
                  // ),

                  // Text('100 Points - 10% Discount to G&F', style: body),
                  // SizedBox(height: 10),
                  // Text('500 Points - \$10 coupon for PriZurv', style: body),
                  // SizedBox(height: 20),
                  // Text('To Redeem Points: email circulrshop@gmail.com.')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
