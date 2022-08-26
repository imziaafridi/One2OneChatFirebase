import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messagingapplication/auth/signup.dart';
import 'package:messagingapplication/chat/tabsnaviagtions.dart';
import 'package:provider/provider.dart';

import '../provider/user-auth.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);
  static const routeName = "signin";

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  final User? currentuser = FirebaseAuth.instance.currentUser;
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Signin Screen",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 30),
                  child: const Text(
                    "Login",
                    textScaleFactor: 1.8,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.10,
                ),
                _email(),
                const SizedBox(
                  height: 20,
                ),
                _password(),
                const SizedBox(
                  height: 20,
                ),
                Consumer<Auth>(
                  builder: (context, auth, _) {
                    return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              auth
                                  .signin(_emailcontroller.text.trim(),
                                      _passwordcontroller.text.trim())
                                  .then((_) => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TabsNavigations(),
                                      ),
                                      (route) => false));
                            },
                            child: const Text("User Login")));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("if user is not already signed in then"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ));
                        },
                        child: const Text("Signup")),
                    const Text(
                      "to continue.",
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _email() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        hintText: "Enter Email Address",
        label: const Text("Email"),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      controller: _emailcontroller,
      maxLength: 20,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextField _password() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        hintText: "Enter Password",
        label: const Text("Password"),
        prefixIcon: const Icon(Icons.lock_clock_outlined),
      ),
      obscureText: true,
      controller: _passwordcontroller,
      maxLength: 20,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
