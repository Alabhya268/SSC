import 'dart:async';

import 'package:cheque_app/landing_screen.dart';
import 'package:flutter/material.dart';

import 'utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LandingScreen()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: kBackgroundBoxStyle,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/logos/launcher_icon.png',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text(
                    "SSC",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    color: kRegularColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }
}
