import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messagingapplication/chat/tabsnaviagtions.dart';
import 'package:messagingapplication/provider/user-auth.dart';
import 'package:messagingapplication/provider/user-collections.dart';
import 'package:messagingapplication/route.dart';
import 'package:provider/provider.dart';

import 'auth/siginin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserCollections(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreenSwitches(),
        routes: routes,
      ),
    );
  }
}

// ignore: must_be_immutable
class ScreenSwitches extends StatelessWidget {
  ScreenSwitches({Key? key}) : super(key: key);

  CollectionReference cref = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return TabsNavigations();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("something went wrong ${snapshot.error}"));
        } else {
          return SigninScreen();
        }
      },
    );
  }
}
