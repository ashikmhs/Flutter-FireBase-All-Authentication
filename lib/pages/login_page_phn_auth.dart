import 'package:authentication_demo/pages/phn_auth_completed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPageByPhoneNum extends StatefulWidget {
  @override
  _LoginPageByPhoneNumState createState() => _LoginPageByPhoneNumState();
}

class _LoginPageByPhoneNumState extends State<LoginPageByPhoneNum> {
  //for phone Numner Authentication

  final _txcontroller = TextEditingController();
  final _txfromcontroller = TextEditingController();

  Future<bool> _phnSignin(String phone, BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          //this call back only gets called when verification dobe by codeAutoRetrivalTimeou
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhnAuthCompleted(
                  user: user,
                ),
              ),
            );
          } else {
            print('error');
          }
        },
        verificationFailed: (AuthException error) {
          print(error);
        },
        codeSent: (String verificationId, [int forseResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text('Enter the code'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _txfromcontroller,
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                                  verificationId: verificationId,
                                  smsCode: _txfromcontroller.text.trim());
                          AuthResult result =
                              await _auth.signInWithCredential(credential);

                          FirebaseUser user = result.user;
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhnAuthCompleted(
                                  user: user,
                                ),
                              ),
                            );
                          } else {
                            print('error');
                          }
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  controller: _txcontroller,
                  decoration: InputDecoration(
                    hintText: "Enter Phone number",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                OutlineButton(
                  onPressed: () {
                    final phonee = _txcontroller.text.trim();
                    _phnSignin(phonee, context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
