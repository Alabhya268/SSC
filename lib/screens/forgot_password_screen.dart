import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();

  TextEditingController _emailController = TextEditingController();

  bool _isEmailExist = false;
  String _resetError = '';
  bool _isLoading = false;

  Widget _buildResetBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: !_isLoading
            ? () async {
                setState(() {
                  _isLoading = true;
                });

                await _firebaseServices.emailExist(_emailController.text)
                    ? _isEmailExist = true
                    : _isEmailExist = false;

                if (_isEmailExist) {
                  _firebaseServices.firebaseAuth
                      .sendPasswordResetEmail(email: _emailController.text)
                      .onError(
                        (error, stackTrace) => _resetError = error.toString(),
                      );
                  if (_resetError == '') {
                    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                      SnackBar(
                        content: Text(
                          'An email has been sent to your email please continue there.',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                      SnackBar(
                        content: Text(
                          '$_resetError',
                        ),
                      ),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  ScaffoldMessenger.maybeOf(context)!.showSnackBar(
                    SnackBar(
                      content: Text(
                        'This email is not registered, Please try again with different email',
                      ),
                    ),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            : null,
        child: Text(
          'Reset password',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logos/launcher_icon.png',
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'SSC',
              style: kTextStyleRegular,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: kBackgroundBoxStyle,
            child: Container(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Password assistance',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    BuildInput(
                      fieldName: 'Enter email associated with SSC',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      passwordfield: false,
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildResetBtn(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
