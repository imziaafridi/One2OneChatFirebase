import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagingapplication/chat/tabsnaviagtions.dart';
import 'package:messagingapplication/customs.dart';
import 'package:messagingapplication/provider/user-collections.dart';
import 'package:provider/provider.dart';

class HandleRequests extends StatelessWidget {
  HandleRequests({
    Key? key,
  }) : super(key: key);
  CollectionReference cref = FirebaseFirestore.instance.collection("requests");
  CollectionReference chatRef = FirebaseFirestore.instance.collection("chat");
  String receiveId = " ";
  String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Requests",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white70),
        leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TabsNavigations(),
                )),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder(
        stream: cref.orderBy("created", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("something went wrong!");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, int index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  userid == doc["receiver"] ? indexVal = index : 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: Column(
                      children: [
                        if (userid == doc["sender"] ||
                            userid == doc["receiver"])
                          ListTile(
                            subtitle: Text(userid == doc["sender"]
                                ? doc["receiver"]
                                : doc["sender"]),
                            title: Text(userid == doc["receiver"]
                                ? "Request has been receive by user id"
                                : "${doc["type"]}:\tRequest has been sent to user id "),
                          ),
                        if (userid == doc["receiver"] &&
                            userid != doc["sender"])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  String chatDocID = chatRef.doc().id;
                                  Provider.of<UserCollections>(context,
                                      listen: false);
                                  await chatRef.doc(chatDocID).set({
                                    "doc-id": chatDocID,
                                    "sender": doc["sender"],
                                    "receiver": doc["receiver"],
                                    "messageType": "sender",
                                    "created": DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                  }).whenComplete(() async {
                                    await cref.doc(doc["doc-id"]).delete();
                                    showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                        title: Text(
                                            "user request has been accepted"),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    fixedSize:
                                        Size.fromHeight(size.height * 0.02)),
                                child: const Text("Accept"),
                              ),
                              if (userid == doc["receiver"])
                                OutlinedButton(
                                  onPressed: () async {
                                    await cref.doc(doc["doc-id"]).delete();
                                    showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                        title: Text(
                                            "user request has been deleted"),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize:
                                        Size.fromHeight(size.height * 0.04),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                  ),
                                  child: const Text("Reject"),
                                ),
                            ],
                          ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
