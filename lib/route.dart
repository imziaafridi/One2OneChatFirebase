import 'package:flutter/material.dart';
import 'package:messagingapplication/auth/siginin.dart';
import 'package:messagingapplication/auth/signup.dart';
import 'package:messagingapplication/chat/chats.dart';
import 'package:messagingapplication/chat/tabsnaviagtions.dart';
import 'package:messagingapplication/chat/users.dart';

Map<String, Widget Function(BuildContext)> routes = {
  SignupScreen.routeName: (context) => const SignupScreen(),
  SigninScreen.routeName: (context) => SigninScreen(),
  TabsNavigations.routeName: (context) => TabsNavigations(),
  ChatScreen.routeName: (context) => ChatScreen(),
  UsersScreen.routeName: (context) => UsersScreen(),
};
