import 'package:flutter/material.dart';
import 'package:geoquiz/app/sign_in_page.dart';
import 'package:geoquiz/common/keys.dart';
import 'package:provider/provider.dart';

import '../common/colors.dart';
import '../common/spaced_column.dart';
import '../services/auth.dart';
import '../services/validators.dart';

class SignInForm extends StatefulWidget with Keys {
  const SignInForm({Key? key, required this.formType, required this.switchFormType, required this.isLoading, required this.setIsLoading, this.onSignedIn}) : super(key: key);
  final EmailSignInFormType formType;
  final VoidCallback? switchFormType;
  final bool? isLoading;
  final void Function(bool)? setIsLoading;
  final VoidCallback? onSignedIn;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12.0,
      children: [
        _buildEmailTextField(),
        _buildPasswordTextField(auth),
        _buildSubmitButton(auth),
        const SizedBox(
          height: 4.0,
        ),
        if (widget.switchFormType != null) _buildSwitchFormTypeButton(),
      ],
    );
  }

  Widget _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.isLoading! && !emailValidator.isValid(_email);
    return TextFormField(
      key: Keys.signInFormEmailField,
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: 'Email',
        errorText: showErrorText ? emailValidator.errorText : null,
      ),
      autocorrect: false,
      enabled: !widget.isLoading!,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: () => _emailEditingComplete(),
      validator: (email) =>
          emailValidator.isValid(email!) ? null : emailValidator.errorText,
    );
  }

  Widget _buildPasswordTextField(AuthBase auth) {
    bool showErrorText = _submitted && !widget.isLoading! && !passwordValidator.isValid(_password);
    return TextFormField(
      key: Keys.signInFormPasswordField,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: 'Password',
        errorText: showErrorText ? passwordValidator.errorText : null,
      ),
      obscureText: true,
      enabled: !widget.isLoading!,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => _submit(auth),
      onChanged: (password) => _updateState(),
      validator: (password) => passwordValidator.isValid(password!) ? null : passwordValidator.errorText,
    );
  }

  Widget _buildSubmitButton(AuthBase auth) {
    bool submitEnabled = emailValidator.isValid(_email) && passwordValidator.isValid(_password) && !widget.isLoading!;
    return ElevatedButton(
      key: Keys.signInEmailButton,
      onPressed: !submitEnabled ? null : () => _submit(auth),
      style: ElevatedButton.styleFrom(
        primary: AppColors.primary,
        minimumSize: const Size(120.0, 40.0),
      ),
      child: Text(
          widget.formType == EmailSignInFormType.signup ? 'Sign up' : 'Sign in',
          style: const TextStyle(fontSize: 20.0, color: AppColors.textLight, fontWeight: FontWeight.bold)
      ),
    );
  }

  Widget _buildSwitchFormTypeButton() {
    return TextButton(
      key: Keys.signInFormEmailField,
      onPressed: widget.isLoading! ? null : widget.switchFormType,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200.0, 24.0),
      ),
      child: Text(widget.formType == EmailSignInFormType.signup ? 'Already have an account? Sign in' : 'Need a new account? Sign up'),
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
      widget.onSignedIn?.call();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        widget.setIsLoading!(false);
      });
      Navigator.of(context).pop();
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
