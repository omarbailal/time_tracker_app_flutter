import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

import 'email_sign_in_model.dart';


class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators{

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if(_formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(_email, _password);
      }else{
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
       context,
       title: 'Sign in failed',
       exception: e,
     );
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }
  void _toggleFormType(){
    print('form type $_formType');
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
      print('form type after change $_formType');
      _submitted = false;
    });
  }

  List<Widget> _buildChildren(){
    final primaryType = _formType == EmailSignInFormType.signIn? 'Sign in' : 'Create an account';
    final secondaryType = _formType == EmailSignInFormType.signIn? 'Need an account? Register' : 'Have an account? Sign in';
    bool submitEnable = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) && !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(height: 10.0,),
      _buildPasswordTextField(),
      SizedBox(height: 10.0,),
      FormSubmitButton(
        text: primaryType,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(height: 10.0,),
      TextButton(
        onPressed: !_isLoading? _toggleFormType : null,
        child: Text(secondaryType),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = !widget.passwordValidator.isValid(_password) && _submitted;
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = !widget.emailValidator.isValid(_email) && _submitted;
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText? widget.invalidEmailErrorText: null,
        enabled: _isLoading == false,
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children:  _buildChildren(),
      ),
    );
  }



  void _updateState() {
    print('state updated');
    setState(() {});
  }
}
