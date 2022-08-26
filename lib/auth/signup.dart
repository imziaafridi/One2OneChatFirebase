import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user-auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const routeName = "signup";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Registration Screen",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 30),
                  child: const Text(
                    "Registration",
                    textScaleFactor: 1.6,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _username(),
                const SizedBox(
                  height: 20,
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
                                  .signup(
                                      _emailcontroller.text.trim(),
                                      _passwordcontroller.text.trim(),
                                      _usernamecontroller.text.trim())
                                  .whenComplete(() => Navigator.pop(context));
                            },
                            child: const Text("User Registers")));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
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
      controller: _passwordcontroller,
      maxLength: 20,
      obscureText: true,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextField _username() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        hintText: "Enter Username",
        label: const Text("username"),
        prefixIcon: const Icon(Icons.person_outline),
      ),
      controller: _usernamecontroller,
      maxLength: 20,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
