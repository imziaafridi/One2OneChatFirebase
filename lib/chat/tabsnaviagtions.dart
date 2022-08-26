import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagingapplication/auth/siginin.dart';
import 'package:messagingapplication/chat/chats.dart';
import 'package:messagingapplication/chat/handleRequets.dart';
import 'package:messagingapplication/chat/users.dart';
import 'package:messagingapplication/customs.dart';

// ignore: must_be_immutable
class TabsNavigations extends StatelessWidget {
  TabsNavigations({Key? key}) : super(key: key);
  static const routeName = "tabs";
  int? index;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("FlutterChatApp",
                style: TextStyle(color: Colors.white70)),
            centerTitle: true,
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HandleRequests(),
                  ));

                  print("Requests");
                },
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(size.width * 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Requests",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text("$indexVal")
                  ],
                ),
              ),
            ],
            leading: IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signOut()
                      .then((_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SigninScreen(),
                          ),
                          (route) => false));
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white70,
                )),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "users",
                ),
                Tab(
                  text: "chat",
                ),
                // Tab(
                //   text: "friends",
                // ),
              ],
            ),
            elevation: 0.0,
            backgroundColor: Colors.black,
            toolbarHeight: 48,
          ),
          body: TabBarView(
            children: [
              UsersScreen(),
              ChatScreen(),
              // const Center(
              //     child: Text(
              //   "this is friends screen",
              //   textScaleFactor: 1.8,
              // )),
            ],
          ),
        ));
  }
}
