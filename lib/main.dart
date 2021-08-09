import 'package:cloudfirebas/pages/login.dart';
import 'package:cloudfirebas/pages/user/usermain.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final storage = new FlutterSecureStorage();
  Future<bool> CheckLoginStatus() async {
    String? value = await storage.read(key: 'uid');

    if (value == null) {
      return false;
    } else {
      return true;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("some things went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter email password Firebase auth',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: FutureBuilder(
                future: CheckLoginStatus(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    return Login();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        color: Colors.white,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return UserMain();
                }),
          );
        });
  }
}
