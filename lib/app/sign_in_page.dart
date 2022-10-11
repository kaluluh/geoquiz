import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoquiz/common/elevated_button_side_icon.dart';
import 'package:geoquiz/common/spaced_column.dart';

import '../services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoQuiz'),
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildSocialButtons(),
      ),
    );
  }

  List<Widget> _buildSocialButtons() {
    return [
        ElevatedButtonSideIcon(
          onPressed: _signInWithGoogle,
          text: 'Sign in with Google',
          icon: SvgPicture.asset(
            'assets/images/google-logo.svg',
            width: 24.0,
            height: 24.0,
          ),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black87),
        ),
        ElevatedButtonSideIcon(
          onPressed: _signInWithFacebook,
          text: 'Sign in with Facebook',
          icon: SvgPicture.asset(
            'assets/images/facebook-logo.svg',
            width: 24.0,
            height: 24.0,
          ),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black87),
        ),
        ElevatedButtonSideIcon(
          onPressed: _signInAnonymously,
          text: 'Sign in anonymously',
        ),
      ];
  }
}