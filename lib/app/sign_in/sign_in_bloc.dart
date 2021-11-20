import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

class SignInBloc{


  SignInBloc(this.auth, this.isLoading);
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  Future<User> _signIn(Future<User> Function() signInMethod) async{
    try{
      isLoading.value = true;
      return await signInMethod();

    }catch(e){
      rethrow;
    }
    finally{
      isLoading.value = false;
    }
  }
  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebbok);

}