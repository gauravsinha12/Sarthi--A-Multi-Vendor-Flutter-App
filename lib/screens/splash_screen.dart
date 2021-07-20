import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../welcome_screens.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id =  'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 5,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
         Navigator.pushReplacementNamed(context, WelcomeScreen.id);


        } else {
         Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset('images/logoo.png'),
      ),
    );
    return scaffold;
  }
}
