import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoquiz/common/elevated_button_side_icon.dart';
import 'package:geoquiz/common/keys.dart';
import 'package:geoquiz/common/spaced_column.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import 'sign_in_form.dart';

enum EmailSignInFormType { login, signup }

class SignInPage extends StatefulWidget with Keys {
  const SignInPage({Key? key, required this.formType, this.onSignedIn})
      : super(key: key);
  final EmailSignInFormType formType;
  final VoidCallback? onSignedIn;

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  late EmailSignInFormType _formType;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _formType = widget.formType;
  }

  Future<void> _signInAnonymously(AuthBase auth, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInAnonymously();
      widget.onSignedIn?.call();
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle(AuthBase auth, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithGoogle();
      widget.onSignedIn?.call();
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithFacebook(AuthBase auth, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithFacebook();
      widget.onSignedIn?.call();
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Scaffold(
      body: _buildContent(auth),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(AuthBase auth) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background_image.png"),
              fit: BoxFit.cover)),
      child: SingleChildScrollView(
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
                      formType: _formType,
                      switchFormType: _switchFormType,
                      isLoading: isLoading,
                      setIsLoading: (isLoading) =>
                          setState(() => this.isLoading = isLoading),
                      onSignedIn: widget.onSignedIn,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SpacedColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 20.0,
                    children: _buildSocialButtons(auth, context),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> _buildSocialButtons(AuthBase auth, BuildContext context) {
    return [
      ElevatedButtonSideIcon(
        key: Keys.signInWithGoogleButton,
        onPressed: isLoading ? null : () => _signInWithGoogle(auth, context),
        text: _formType == EmailSignInFormType.signup
            ? 'Sign up with Google'
            : 'Sign in with Google',
        icon: SvgPicture.asset(
          'assets/images/google-logo.svg',
          width: 24.0,
          height: 24.0,
        ),
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black87),
      ),
      ElevatedButtonSideIcon(
        key: Keys.signInWithFacebookButton,
        onPressed: isLoading ? null : () => _signInWithFacebook(auth, context),
        text: _formType == EmailSignInFormType.signup
            ? 'Sign up with Facebook'
            : 'Sign in with Facebook',
        icon: SvgPicture.asset(
          'assets/images/facebook-logo.svg',
          width: 24.0,
          height: 24.0,
        ),
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black87),
      ),
      ElevatedButtonSideIcon(
        key: Keys.signInAnonymouslyButton,
        onPressed: isLoading ? null : () => _signInAnonymously(auth, context),
        text: 'Sign in anonymously',
      ),
    ];
  }

  void _switchFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.login
          ? EmailSignInFormType.signup
          : EmailSignInFormType.login;
    });
  }
}
