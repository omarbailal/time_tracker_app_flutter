import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';


import 'email_sign_in_page.dart';
import 'logo_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.bloc, required this.isLoading}) : super(key: key);
  final SignInBloc bloc;
  final bool isLoading;

  static get auth => null;


  static Widget create(BuildContext context){
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth, isLoading),
          child: Consumer<SignInBloc>(
              builder:(_, bloc,__) => SignInPage(bloc: bloc, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }


  Future<void> _signInAnonimosly(BuildContext context) async{
    try{
      final user = await bloc.signInAnonymously();
      print('user id : ${user.uid}');
    }on Exception catch(e){
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await bloc.signInWithGoogle();
      print('sign in with Google');
      print('user id : ${user.uid}');

    }on Exception catch(e){
      print(e.toString());
      if(e is FirebaseException && e.code != 'ERROR_ABORTED_BY_USER' ) {
        print('sign in with Google failed');
        showExceptionAlertDialog(
          context,
          title: 'Sign in failed',
          exception: e,
        );
      }
    }finally{
      print('sign in with Google finally');
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final user =await bloc.signInWithFacebook();
    }on Exception catch(e){
      if(e is FirebaseException && e.code != 'ERROR_ABORTED_BY_USER' ) {
        showExceptionAlertDialog(
          context,
          title: 'Sign in failed',
          exception: e,
        );
      }
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 50.0),
          SignInButtonLogo(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            color: Colors.white,
            textColor: Colors.black87,
            borderRaduis: 4,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SignInButtonLogo(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xff334d92),
            textColor: Colors.white,
            borderRaduis: 4,
            onPressed: isLoading? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            color: Colors.teal.shade800,
            textColor: Colors.white,
            borderRaduis: 4,
            onPressed: isLoading? null :  () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text('or', style: TextStyle(fontSize: 14.0, color: Colors.black87), textAlign: TextAlign.center,),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime.shade300,
            textColor: Colors.black,
            borderRaduis: 4,
            onPressed: isLoading? null : () => _signInAnonimosly(context),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader(){
    if(isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  void _testClick() {
    print('button clicked');
  }
}


