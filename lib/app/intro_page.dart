import 'package:flutter/material.dart';
import 'package:geoquiz/app/sign_in_page.dart';

import '../common/spaced_column.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  void _openSignInPage(BuildContext context, bool isSignUp) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignInPage(
          formType: isSignUp ? EmailSignInFormType.signup : EmailSignInFormType.login,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoQuiz'),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: [
          const Text(
            'Welcome to GeoQuiz!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16.0,
            children: [
              // Make them bigger and same width
              ElevatedButton(
                onPressed: () => _openSignInPage(context, false),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120.0, 48.0),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 16.0)),
              ),
              ElevatedButton(
                onPressed: () => _openSignInPage(context, true),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120.0, 48.0),
                  primary: Colors.white,
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16.0, color: Colors.black)),
              ),
            ]
          )
        ],
      ),
    );
  }
}
