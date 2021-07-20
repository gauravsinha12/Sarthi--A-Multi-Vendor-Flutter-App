import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: [
            Image.asset('images/logoo.png'),
            TextField(),
            TextField(),
          ],
        ),
      ),
    );
  }
}
