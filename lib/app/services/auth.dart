import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class User{
//   User({@required this.uid});
//   final String uid;
// }

abstract class AuthBase{
  Stream<User> authStateChanges();
  User get currentUser;
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  void signOut();
  // Stream<User> get onAuthStateChange();
}

class Auth implements AuthBase{

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async{
      final userCredentials = await _firebaseAuth.signInAnonymously();
      return userCredentials.user;
  }

  @override
  Future<User> signInWithGoogle() async{
    final signInWithGoogle = GoogleSignIn();
    final googleUser = await signInWithGoogle.signIn();
    if(googleUser != null){
      final googleAuth = await googleUser.authentication;
      if(googleAuth.idToken != null){
        final userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else{
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_ID_TOKEN',
          message: 'Missing Google Id Token',
        );
      }
    }else{
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in Aborted by user',
      );
    }
  }

  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

}