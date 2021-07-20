import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarthi/provider/auth_provider.dart';
import 'package:sarthi/provider/location_provider.dart';
import 'package:sarthi/screens/homeScreen.dart';
import 'package:sarthi/screens/map_screen.dart';
import 'package:sarthi/screens/onboard_screen.dart';
import 'package:sarthi/screens/splash_screen.dart';
import 'package:sarthi/welcome_screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
    ],
    child: MyApp(),),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue[400]),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
      },
    );
  }
}

