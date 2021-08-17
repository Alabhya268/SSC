import 'dart:async';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();

  late User _user;
  late Timer _timer;

  @override
  void initState() {
    _user = _firebaseServices.getCurrentUser()!;

    _user.sendEmailVerification();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        checkEmailVerified();
      },
    );
    super.initState();
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    _user = _firebaseServices.getCurrentUser()!;
    await _user.reload();
    if (_user.emailVerified) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: kBackgroundBoxStyle,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Please verify account in the link sent to email.',
              style: kLabelStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            decoration: kBoxDecorationStyle,
            child: TextButton.icon(
              onPressed: () {
                _user.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'A verification email has been sent to you email account'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'Resend email verification',
                style: kLabelStyle,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            decoration: kBoxDecorationStyle,
            child: TextButton.icon(
              onPressed: () {
                _firebaseServices.firebaseAuth.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'SignOut',
                style: kLabelStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
