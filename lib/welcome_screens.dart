import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarthi/provider/auth_provider.dart';
import 'package:sarthi/provider/location_provider.dart';
import 'package:sarthi/screens/map_screen.dart';
import 'package:sarthi/screens/onboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _PhoneNumberController = TextEditingController();
    void ShowBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter myState) {
                return Container(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  auth.error == 'Invalid OTP' ? true : false,
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
                                  myState(() {
                                    _validPhoneNumber = true;
                                  });
                                } else {
                                  myState(() {
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
                                        myState(() {
                                          auth.loading = true;
                                        });
                                        String number =
                                            '+91${_PhoneNumberController.text}';
                                        auth
                                            .verifyPhone(context, number)
                                            .then((value) {
                                          _PhoneNumberController.clear();
                                        });
                                      },
                                      color: _validPhoneNumber
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      child: auth.loading
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
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
              }));
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 10.0,
                child: FlatButton(
                  child: Text(
                    'SKIP',
                    style: TextStyle(
                        color: Colors.lightBlue[500],
                        fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {},
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Onboardscreen(),
                  ),
                  Text(
                    'Ready To Order From Your Nearest Shop ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    color: Colors.blue[600],
                    child: locationData.loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'SET DELIVERY LOCATION',
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: () async {
                      setState(() {
                        locationData.loading = true;
                      });
                      await locationData.getCurrentPosition();
                      if (locationData.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                        setState(() {
                          locationData.loading = false;
                        });
                      } else {
                        print('Permission not allowed');
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: RichText(
                        text: TextSpan(
                            text: 'Already a Customer ?  ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            children: [
                          TextSpan(
                              text: ' Login ',
                              style: TextStyle(
                                  color: Colors.blue[400],
                                  fontWeight: FontWeight.w700)),
                        ])),
                    onPressed: () {
                      ShowBottomSheet(context);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
