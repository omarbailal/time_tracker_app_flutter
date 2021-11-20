import 'dart:async';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc{
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();

  EmailSignInBloc({required this.auth});
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  final AuthBase auth;
  void dispose(){
    _modelController.close();
  }
  void updateWith({
     String? email,
     String? password,
     EmailSignInFormType? formType,
     bool? isLoading,
     bool? submitted,
  }){
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if(_model.formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      }else{
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void toggleFormType(){
    final formType = _model.formType == EmailSignInFormType.signIn ? EmailSignInFormType.register : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        submitted: false
    );
  }
}