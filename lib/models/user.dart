// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ourUser {
  late String uid;
  late String email;
  late String fullName;
  late int points;
  late Timestamp accountCreated;

  // OurUser({this.uid, this.email, this.fullName, this.points, this.accountCreated,});
}
