import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoquiz/common/elevated_button_side_icon.dart';
import 'package:geoquiz/common/spaced_column.dart';

import '../services/auth.dart';
import 'sign_in_form.dart';

enum EmailSignInFormType { login, signup }

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.auth, required this.formType})
      : super(key: key);
  final AuthBase auth;
  final EmailSignInFormType formType;

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  late EmailSignInFormType _formType;

  @override
  void initState() {
    super.initState();
    _formType = widget.formType;
  }

  Future<void> _signInAnonymously() async {
    try {
      await widget.auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await widget.auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await widget.auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/images/background_image.png"), fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SignInForm(
                    auth: widget.auth,
                    formType: _formType,
                    switchFormType: _switchFormType,
                ),
              ),
            ),
            SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSocialButtons(),
            ),
          ],
        )
      ),
    );
  }

  List<Widget> _buildSocialButtons() {
    return [
      ElevatedButtonSideIcon(
          onPressed: _signInWithGoogle,
          text: _formType == EmailSignInFormType.signup ? 'Sign up with Google' : 'Sign in with Google',
          icon: SvgPicture.asset(
            'assets/images/google-logo.svg',
            width: 24.0,
            height: 24.0,
          ),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black87),

        ),
      SizedBox(height: 20.0,),
        ElevatedButtonSideIcon(
          onPressed: _signInWithFacebook,

          text: _formType == EmailSignInFormType.signup ? 'Sign up with Facebook' : 'Sign in with Facebook',
          icon: SvgPicture.asset(
            'assets/images/facebook-logo.svg',
            width: 24.0,
            height: 24.0,
          ),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black87),
        ),
      SizedBox(height: 20.0,),
        ElevatedButtonSideIcon(
          onPressed: _signInAnonymously,
          text: 'Sign in anonymously',
        ),
      ];
  }

  void _switchFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.login ? EmailSignInFormType.signup : EmailSignInFormType.login;
    });
  }
}