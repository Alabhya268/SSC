import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/signin_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/signedIn_page_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User?>(context);
    bool _signedIn = _user != null;
    late Stream<bool> userApproved;

    if (_signedIn) {
      userApproved = _firebaseServices.getUserApproved;
    }

    return _signedIn
        ? MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(
                value: _firebaseServices.getCurrentUserDetails(),
                initialData: UserModel(
                  name: '',
                  email: '',
                  role: '',
                  products: [''],
                  registerDate: DateTime.now(),
                  canAddParty: false,
                  canEditOrderStatus: false,
                  orders: 0,
                ),
              ),
              StreamProvider<bool>.value(
                value: userApproved,
                initialData: true,
                lazy: false,
              ),
            ],
            child: SignInPageSelector(),
          )
        : SignInScreen();
  }
}
