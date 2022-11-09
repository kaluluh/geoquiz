import 'package:flutter/material.dart';
import 'package:geoquiz/app/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../common/spaced_column.dart';
import '../services/auth.dart';
import '../services/validators.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key, required this.formType, required this.switchFormType, required this.isLoading, required this.setIsLoading}) : super(key: key);
  final EmailSignInFormType formType;
  final VoidCallback? switchFormType;
  final bool? isLoading;
  final void Function(bool)? setIsLoading;

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

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        _buildEmailTextField(),
        _buildPasswordTextField(auth),
        _buildSubmitButton(auth),
        if (widget.switchFormType != null) _buildSwitchFormTypeButton(),
      ],
    );
  }

  Widget _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.isLoading! && !emailValidator.isValid(_email);
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: showErrorText ? emailValidator.errorText : null,
      ),
      autocorrect: false,
      enabled: !widget.isLoading!,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: () => _emailEditingComplete(),
      validator: (email) => emailValidator.isValid(email!) ? null : emailValidator.errorText,
    );
  }

  Widget _buildPasswordTextField(AuthBase auth) {
    bool showErrorText = _submitted && !widget.isLoading! && !passwordValidator.isValid(_password);
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? passwordValidator.errorText : null,
      ),
      obscureText: true,
      enabled: !widget.isLoading!,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => _submit(auth),
      validator: (password) => passwordValidator.isValid(password!) ? null : passwordValidator.errorText,
    );
  }

  Widget _buildSubmitButton(AuthBase auth) {
    return ElevatedButton(
      onPressed: widget.isLoading! ? null : () => _submit(auth),
      child: Text(widget.formType == EmailSignInFormType.signup ? 'Create an Account' : 'Sign in'),
    );
  }

  Widget _buildSwitchFormTypeButton() {
    return TextButton(
      onPressed: widget.isLoading! ? null : widget.switchFormType,
      child: Text(widget.formType == EmailSignInFormType.signup ? 'Have an account? Sign in' : 'Need an account? Sign up'),
    );
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _updateState() {
    setState(() {});
  }

  void _submit(AuthBase auth) async {
    setState(() {
      _submitted = true;
      widget.setIsLoading!(true);
    });
    try {
      if (widget.formType == EmailSignInFormType.login) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        widget.setIsLoading!(false);
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
