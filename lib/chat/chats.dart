import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);
  static const routeName = "chats";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference chatRef = FirebaseFirestore.instance.collection("chat");
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: chatRef.orderBy("created", descending: false).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("something went wrong!");
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot chatSnapshot = snapshot.data!.docs[index];
                String chatDocumentId = chatSnapshot["doc-id"];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      if (user!.uid == chatSnapshot["sender"] ||
                          user!.uid == chatSnapshot["receiver"])
                        ListTile(
                          title: Text("user id $chatDocumentId :"),
                          subtitle: Text(user!.uid == chatSnapshot["sender"]
                              ? chatSnapshot["receiver"]
                              : chatSnapshot["sender"]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MessagingScreen(
                                  chatDocumentId: chatDocumentId),
                            ));
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MessagingScreen extends StatefulWidget {
  MessagingScreen({Key? key, required this.chatDocumentId}) : super(key: key);
  final String chatDocumentId;
  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  CollectionReference chatRef = FirebaseFirestore.instance.collection("chat");

  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chat Screen",
          ),
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: chatRef
              .doc(widget.chatDocumentId)
              .collection("messages")
              .orderBy("createdAt", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                primary: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot messageDoc = snapshot.data!.docs[index];
                  // messageDoc[];

                  if (userId != messageDoc["currentUser"]) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.topLeft,
                      child: ListTile(
                          title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              messageDoc["message"],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                    );
                  } else {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: userId == messageDoc["currentUser"]
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 7, 107, 188)),
                              child: Text(
                                messageDoc["message"],
                                style: const TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
        bottomSheet: MessagesHandler(chatDocumentId: widget.chatDocumentId),
      ),
    );
  }
}

class MessagesHandler extends StatefulWidget {
  const MessagesHandler({Key? key, required this.chatDocumentId})
      : super(key: key);
  final String chatDocumentId;
  @override
  State<MessagesHandler> createState() => _MessagesHandlerState();
}

class _MessagesHandlerState extends State<MessagesHandler> {
  final TextEditingController messages = TextEditingController();

  @override
  void dispose() {
    messages.dispose();
    super.dispose();
  }

  CollectionReference chatRef = FirebaseFirestore.instance.collection("chat");
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 20, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Send Message Here",
                  label: const Text("message"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  prefixIcon: const Icon(Icons.emoji_emotions_outlined)),
              controller: messages,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              String messageId = chatRef.doc().id;
              chatRef
                  .doc(widget.chatDocumentId)
                  .collection("messages")
                  .doc(messageId)
                  .set({
                "currentUser": userId,
                "messageId": messageId,
                "message": messages.text.trim(),
                "createdAt": DateTime.now(),
              });
              messages.text = " ";
              FocusManager.instance.primaryFocus!.unfocus();
            },
            elevation: 0.0,
            tooltip: "send",
            backgroundColor: Colors.black87,
            child: const Icon(Icons.send),
          ),
        )
      ],
    );
  }
}
