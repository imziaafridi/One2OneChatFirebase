import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCollections with ChangeNotifier {
  CollectionReference cref = FirebaseFirestore.instance.collection("chat");
  CollectionReference uref = FirebaseFirestore.instance.collection("users");

  User? currentuser = FirebaseAuth.instance.currentUser;
  Future addChatCollections() async {}
}
