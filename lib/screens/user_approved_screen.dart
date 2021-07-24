import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserApprovedScreen extends StatefulWidget {
  const UserApprovedScreen({Key? key}) : super(key: key);

  @override
  _UserApprovedScreenState createState() => _UserApprovedScreenState();
}

class _UserApprovedScreenState extends State<UserApprovedScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
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
              'Your account has yet not been approved by admin. \n Try again later.',
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
