import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarthi/screens/homeScreen.dart';
import 'package:sarthi/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;

  Future<void> verifyPhone(BuildContext context, String number) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificatonFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };
    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificatonFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          });
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 Digit OTP Recived as SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);
                      final User user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;

                      _createUser(id: user.uid, number: user.phoneNumber);

                      if (user != null) {
                        Navigator.of(context).pop();

                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      } else {
                        print('login failed');
                      }
                    } catch (e) {
                      this.error = 'Invalid OTP';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'DONE',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          );
        });
  }

  void _createUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'location': GeoPoint(latitude, longitude),
      'address': address,
    });
  }

  void _updateUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address}) {
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'location': GeoPoint(latitude, longitude),
      'address': address,
    });
  }
}
