import 'package:flutter/material.dart';
import 'package:circulr_app/styles.dart';
import 'widgets/FAQ.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: cBeige,
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: primary,
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       ExpansionTile(
      //         title: Text(
      //             'Can I return packaging from brands you don’t work with?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'Yes! We accept glass jars from any brand. We clean this packaging and then sell it back to interested small businesses. Use the “generic jar” option to return these items.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text(
      //             'How is a delayed deposit better/different than a “normal” deposit?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'The problem with “normal” deposits is that they keep your money in limbo. This means that living green becomes cost-prohibitive. We are working with brands to test out a delayed deposit. Through this format, you don’t have to pay any deposit! \n\nThe only situation where you pay is if you don’t return the packaging within a certain amount of time, like a library book. If you return it after you’ve already been charged, then we will refund you the full deposit amount.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title:
      //             Text('Is reuse safe and sanitary?', style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'We know during this pandemic many people are worried about sanitation in reuse. Though scientists have said reuse is safe during COVID, Circulr takes special care to ensure our process is sanitary and safe. All of the packaging returned to our bins is washed and sanitized in order to ensure any germs or bacteria are removed. Once the containers are clean they are packaged and sealed before being shipped back to the supplier for reuse.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text('What can I use Circulr Points for?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'Reuse shouldn\'t be a chore. For this reason, we decided to incentivize customer reuse by offering rewards. Points are given to users who take certain actions. For a full description of our rewards program click here.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text(
      //             'My packaging is damaged/ cracked, can I still return it?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'Unfortunately, we’re only able to accept packaging that is in the same condition it was in when you purchased it. If there are any cracks, dents, or other damage, we kindly ask that you recycle the package.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text(
      //             'Can I return the packaging even if I did not track it when I purchased it?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'Yes! We accept all of the packaging listed on our what we collect page, regardless of when it was purchased, or if it was tracked.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text(
      //             'Do I have to wash my containers before returning them?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'No, but we do ask that you rinse out any remaining food from the container. A simple rinse makes the washing process much easier!',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //       ExpansionTile(
      //         title: Text(
      //             'Do I have to return the packaging to the same location I bought it?',
      //             style: bodyHighlightBlue),
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(width: 15),
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.8,
      //                 child: Text(
      //                     'No, you can return the packaging to any of the collection sites in our network.',
      //                     style: body),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: FAQ(),
    );
  }
}
