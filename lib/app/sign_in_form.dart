import 'package:flutter/material.dart';
import 'package:geoquiz/app/home_page.dart';
import 'package:geoquiz/app/sign_in_page.dart';

import '../common/spaced_column.dart';
import '../services/auth.dart';
import '../services/validators.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key, required this.auth, required this.formType, this.switchFormType}) : super(key: key);
  final AuthBase auth;
  final EmailSignInFormType formType;
  final VoidCallback? switchFormType;

  @override
  State<SignInForm> createState() => _SignIpFormState();
}

class _SignIpFormState extends State<SignInForm> with EmailLoginFormValidators {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        _buildEmailTextField(),
        _buildPasswordTextField(),
        _buildSubmitButton(),
        if (widget.switchFormType != null) _buildSwitchFormTypeButton(),
      ],
    );
  }

  Widget _buildEmailTextField() {
    bool showErrorText = _submitted && !emailValidator.isValid(_email);
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: showErrorText ? emailValidator.errorText : null,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: () => _emailEditingComplete(),
      validator: (email) => emailValidator.isValid(email!) ? null : emailValidator.errorText,
    );
  }

  Widget _buildPasswordTextField() {
    bool showErrorText = _submitted && !passwordValidator.isValid(_password);
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? passwordValidator.errorText : null,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      validator: (password) => passwordValidator.isValid(password!) ? null : passwordValidator.errorText,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      child: Text(widget.formType == EmailSignInFormType.signup ? 'Sign up' : 'Sign in'),
    );
  }

  Widget _buildSwitchFormTypeButton() {
    return TextButton(
      onPressed: widget.switchFormType,
      child: Text(widget.formType == EmailSignInFormType.signup ? 'Have an account? Sign in' : 'Need an account? Sign up'),
    );
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _updateState() {
    setState(() {});
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (widget.formType == EmailSignInFormType.login) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
