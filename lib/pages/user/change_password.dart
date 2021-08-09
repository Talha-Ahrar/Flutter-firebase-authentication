import 'package:cloudfirebas/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({Key? key}) : super(key: key);

  @override
  _ChangepasswordState createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final _formkey = GlobalKey<FormState>();
  var newPassword = '';
  final newPasswordcontroller = TextEditingController();
  void dispose() {
    newPasswordcontroller.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.teal,
        content: Text(
          'Your Password Has been change',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password', hintText: 'Enter New Password'),
                controller: newPasswordcontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () => {
                      if (_formkey.currentState!.validate())
                        {
                          setState(() {
                            newPassword = newPasswordcontroller.text;
                          }),
                          changePassword()
                        }
                    },
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
  }
}
