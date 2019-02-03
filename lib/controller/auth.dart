import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();

  Future<FirebaseUser> signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    return user;
  }

  // void _signOut(BuildContext context) {
  //   _gSignIn.signOut();
  //   print('Signed out');
  // }

}