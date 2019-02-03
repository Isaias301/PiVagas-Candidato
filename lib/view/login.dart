import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pivagas_candidado/view/listar_vaga.dart';
import 'package:pivagas_candidado/view/auth_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {

    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    return user;
  }


  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text('PiVagas Empresa'),
    );

    final loginButtonGmail = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          _signIn(context)
          .then((FirebaseUser user) => 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListViewVaga()),
            ))
          .catchError((e) => print(e));
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFFD50000),
        child: Text('LOGIN COM GMAIL', style: TextStyle(color: Colors.white)),
      ),
    );

    final loginButtonPhone = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthSmsPage()));
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFFFAFAFA),
        child: Text('LOGIN COM TELEFONE', style: TextStyle(color: Colors.black)),

      ),
    );

    final loginButtonFacebook = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthSmsPage()));
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFF0D47A1),
        child: Text('LOGIN COM FACEBOOK', style: TextStyle(color: Colors.white)),

      ),
    );

    final loginButtonGitHub = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthSmsPage()));
        },
        padding: EdgeInsets.all(12),
        color: const Color(0xFFFAFAFA),
        child: Text('LOGIN COM GITHUB', style: TextStyle(color: Colors.black)),

      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // logo,
            // SizedBox(height: 48.0),
            // email,
            // SizedBox(height: 8.0),
            // password,
            SizedBox(height: 24.0),
            loginButtonGmail,
            loginButtonPhone,
            // loginButtonFacebook,
            // loginButtonGitHub
          ],
        ),
      ),
    );
  }

}