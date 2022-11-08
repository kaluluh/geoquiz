import 'package:flutter/material.dart';
import 'package:geoquiz/app/sign_in_page.dart';
import 'package:geoquiz/services/auth.dart';

import '../common/spaced_column.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  void _openSignInPage(BuildContext context, bool isSignUp) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignInPage(
          auth: auth,
          formType:
              isSignUp ? EmailSignInFormType.signup : EmailSignInFormType.login,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
     // backgroundColor: Colors.purple.withOpacity(0.5),
    );
  }

  _buildContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),

        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/images/background_image.png"), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'let\u0027s explore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(253, 205, 28, 1),
                ),
              ),
              const Text(
                'THE WORLD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(245, 245, 245, 1),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                onPressed: () => _openSignInPage(context, false),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(30, 197, 187, 1),
                  minimumSize: const Size(140.0, 70.0),
                ),
                child: const Text(
                  'Play',
                  style: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Colors.black,
                      ),


                    ],
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Make them bigger and same width
                    ElevatedButton(
                      onPressed: () => _openSignInPage(context, false),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120.0, 48.0),
                        primary:  Color.fromRGBO(253, 205, 28, 1),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () => _openSignInPage(context, true),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120.0, 48.0),
                        primary: Color.fromRGBO(11, 11, 56, 1),
                      ),
                      child: const Text('Sign Up',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ])
            ],
          ),
        ));
  }
}
