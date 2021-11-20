// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

import 'email_sign_in_model.dart';


class EmailSignInFormBlocBased extends StatefulWidget with EmailAndPasswordValidators{
  EmailSignInFormBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder:(_, bloc,__) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }
  @override
  State<EmailSignInFormBlocBased> createState() => _EmailSignInFormStateBlocBasedState();
}

class _EmailSignInFormStateBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }



  void _emailEditingComplete() {

    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }
  void _toggleFormType(EmailSignInModel model){
    print('form type ${model.formType}');
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model){
    final primaryType = model.formType == EmailSignInFormType.signIn? 'Sign in' : 'Create an account';
    final secondaryType = model.formType == EmailSignInFormType.signIn? 'Need an account? Register' : 'Have an account? Sign in';
    bool submitEnable = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return [
      _buildEmailTextField(model),
      const SizedBox(height: 10.0,),
      _buildPasswordTextField(model),
      const SizedBox(height: 10.0,),
      FormSubmitButton(
        text: primaryType,
        onPressed: submitEnable ? _submit : null,
      ),
      const SizedBox(height: 10.0,),
      TextButton(
        onPressed: !model.isLoading? () => _toggleFormType(model) : null,
        child: Text(secondaryType),
      ),
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText = !widget.passwordValidator.isValid(model.password) && model.submitted;
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => widget.bloc.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText = !widget.emailValidator.isValid(model.email) && model.submitted;
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText? widget.invalidEmailErrorText: null,
        enabled: model.isLoading == false,
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => widget.bloc.updateWith(email: email),

    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children:  _buildChildren(model!),
          ),
        );
      }
    );
  }

}
