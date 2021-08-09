import 'package:cloudfirebas/pages/forgot_password.dart';
import 'package:cloudfirebas/pages/signup.dart';
import 'package:cloudfirebas/pages/user/usermain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  var email = '';
  var password = '';
  final emailcontroller = TextEditingController();
  final posswordcontroller = TextEditingController();
  final storage = new FlutterSecureStorage();
  void dispose() {
    emailcontroller.dispose();
    posswordcontroller.dispose();
    super.dispose();
  }

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await storage.write(key: 'uid', value: userCredential.user!.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserMain(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text(
            'No user found for that Email',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text(
            'Password incorrect',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15.0)),
                  controller: emailcontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter Valid Email';
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15.0)),
                  controller: posswordcontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password ';
                    } else if (value.length < 6) {
                      return 'Password more then 6 charactor!';
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = emailcontroller.text;
                              password = posswordcontroller.text;
                            });
                            userLogin();
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        )),
                    TextButton(
                        onPressed: () => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, a, b) =>
                                          ForgotPassword(),
                                      transitionDuration: Duration(seconds: 0)),
                                  (route) => false)
                            },
                        child: Text(
                          'Forgotton Password',
                          style: TextStyle(fontSize: 14.0),
                        ))
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont have an account?'),
                    TextButton(
                        child: Text('Siginup'),
                        onPressed: () => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, a, b) => Signup(),
                                      transitionDuration: Duration(seconds: 0)),
                                  (route) => false)
                            })
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              //   Container(
              //     child: OutlineButton.icon(
              //       label: Text(
              //         'Sign In With Google',
              //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //       ),
              //       shape: StadiumBorder(),
              //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              //       highlightedBorderColor: Colors.black,
              //       borderSide: BorderSide(color: Colors.black),
              //       textColor: Colors.black,
              //       icon: FaIcon(FontAwesomeIcons.google, color: Colors.teal),
              //       onPressed: () {
              //          final provider =
              //     Provider.of<GoogleSignInProvider>(context, listen: false);
              // provider.login();
              //       },
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
