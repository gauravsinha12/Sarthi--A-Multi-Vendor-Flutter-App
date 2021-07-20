import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarthi/provider/auth_provider.dart';
import 'package:sarthi/provider/location_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    bool _validPhoneNumber = false;
    var _PhoneNumberController = TextEditingController();
    return Container(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: auth.error == 'Invalid OTP' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          '${auth.error} - Try again',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Enter Your Phone Number To Proceed',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixText: '+91',
                    labelText: ' 10 Digits Mobile Number ',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _PhoneNumberController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState(() {
                        _validPhoneNumber = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              auth.loading = true;
                            });
                            String number = '+91${_PhoneNumberController.text}';
                            auth.verifyPhone(context, number).then((value) {
                              _PhoneNumberController.clear();
                            });
                          },
                          color: _validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          child: auth.loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  _validPhoneNumber
                                      ? 'CONTINUE'
                                      : 'ENTER THE PHONE NUMBER',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
