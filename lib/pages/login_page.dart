import 'package:authentication_demo/components/text_field_style.dart';
import 'package:authentication_demo/pages/google_auth_complete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'login_page_phn_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String UserName;
  String Password;
  //for firebase facebook authentication
  _fbSignIn() async {
    try {
      final FacebookLogin facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
      print(graphResponse.body);
      if (result.status == FacebookLoginStatus.loggedIn) {
        print("Success");
        final credential =
            FacebookAuthProvider.getCredential(accessToken: token);
        _auth.signInWithCredential(credential);
      }
    } catch (error) {
      print(error.message);
    }
    /* setState(() {
      _fbisSignIn = true;
    });*/
  }

  //for firebase google authentication
  Future<FirebaseUser> _gsignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      //for signIn to present the user with an authentication dialog instead of silently and automatically re-using the current Google user.
      await _googleSignIn.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleAuthComplete(user: user),
        ),
      );
//      print("User name: ${user.displayName}");
//      print("User photo: ${user.photoUrl}");
//      print("User email: ${user.email}");
      return user;
    } catch (e) {
      print(e);
    }
  }

  //for email password auth
  Future signInWIthEMailPass(userName, passWord) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: userName, password: passWord);
      FirebaseUser user = result.user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.red,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/logo.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Textfield(
                  onChange: (val) {
                    UserName = val;
                  },
                  icon: Icons.account_circle,
                  text: 'Username',
                  keyboardtype: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Textfield(
                  onChange: (val) {
                    Password = val;
                  },
                  icon: Icons.screen_lock_portrait,
                  text: 'Password',
                  keyboardtype: TextInputType.visiblePassword,
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 0.0),
                child: Text(
                  'Forger password?',
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ),
              LoginButton(
                onTap: () {
                  signInWIthEMailPass(UserName, Password);
                },
                text: 'LOGIN',
                textColor: Colors.red,
                backgroundColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _fbSignIn();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Facebook",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _gsignIn();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Google",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              LoginButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPageByPhoneNum(),
                    ),
                  );
                },
                text: 'Mobile Number',
                textColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Container(
                  child: Text(
                    'Don\'t have an account ?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
