import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  FirebaseAuth authfirbase = FirebaseAuth.instance;
  CollectionReference cref = FirebaseFirestore.instance.collection("users");

  Future signup(String email, String password, String username) async {
    SharedPreferences spref = await SharedPreferences.getInstance();

    final UserCredential userCred = await authfirbase
        .createUserWithEmailAndPassword(email: email, password: password);
    await cref.doc(userCred.user!.uid).set({
      "userId": userCred.user!.uid,
      "email": email,
      "username": username,
    });

    spref.setString("username", username);
    notifyListeners();
  }

  Future signin(String email, String password) async {
    await authfirbase.signInWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
  }
}
