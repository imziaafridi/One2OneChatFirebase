import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UsersScreen extends StatefulWidget {
  UsersScreen({Key? key}) : super(key: key);
  static const routeName = "users";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

bool isloading = false;

class _UsersScreenState extends State<UsersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference userref =
      FirebaseFirestore.instance.collection("users");
  CollectionReference cref = FirebaseFirestore.instance.collection("requests");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: userref.where("userId", isNotEqualTo: user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "${documentSnapshot["username"]}",
                          textScaleFactor: 1.4,
                        ),
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black87,
                            child: Text(
                              "${index + 1}",
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )),
                        subtitle: Text("${documentSnapshot["email"]}"),
                        onTap: () {},
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String docId = cref.doc().id;
                          String userId = user!.uid;
                          await cref.doc(docId).set({
                            "doc-id": docId,
                            "sender": userId,
                            "receiver": documentSnapshot["userId"],
                            "type": "sender",
                            "created": DateTime.now(),
                          }).whenComplete(() {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text("Request has been sent."),
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 60)),
                        child: const Text("Send Request"),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomSheet: Container(
          decoration: BoxDecoration(
              // color: Colors.black87,
              border: Border.all(color: Colors.black87, width: 0.4)),
          margin: EdgeInsets.only(left: size.width * 0.35, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            user!.email.toString(),
          )),
    );
  }
}

/*



 */
