import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarthi/provider/auth_provider.dart';
import 'package:sarthi/welcome_screens.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      // ignore: deprecated_member_use
      // ignore: missing_required_param
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
RaisedButton(
        onPressed: (){
          auth.error = '';
          FirebaseAuth.instance.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
          });
        },
        child: Text('Sign Out'),
      ),
      RaisedButton(
        onPressed: (){
         Navigator.pushNamed(context, WelcomeScreen.id);
        },
        child: Text('Home Screen'),
      ),
        ],
      ),
      ),
      );
      
  }
}