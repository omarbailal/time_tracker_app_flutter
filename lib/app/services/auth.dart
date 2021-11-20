import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
abstract class AuthBase{
  User get currentUser;
  Future<User> signInAnonymously();
  Future<void> signOut();
  Stream<User> authStateChanges();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebbok();
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInWithEmailAndPassword(String email, String password);
}
class Auth implements AuthBase{
  Stream<User> authStateChanges() => FirebaseAuth.instance.authStateChanges();
  User get currentUser => FirebaseAuth.instance.currentUser;
  Future<User> signInAnonymously() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        print('user : ${userCredential.user.email}');
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
  Future<User> signInWithFacebbok() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    switch(response.status){
      case FacebookLoginStatus.Success:
        final accessToken = response.accessToken;
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        print('user facebook email: ${userCredential.user.email}');
        return userCredential.user;
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBBOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }

  }
  Future<User> signInWithEmailAndPassword(String email, String password) async{
    final userCredentials = await FirebaseAuth.instance.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredentials.user;
  }
  Future<User> createUserWithEmailAndPassword(String email, String password) async{
    final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return userCredentials.user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }
}