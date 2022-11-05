import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoquiz/app/home_page.dart';
import 'package:geoquiz/app/intro_page.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/database.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return IntroductionPage(
              auth: auth,
            );
          }
          // return HomePage(
          //   auth: auth,
          // );
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: HomePage(
              auth: auth,
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}