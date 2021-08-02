import 'package:flutter/material.dart';

final kRegularColor = Color(0xFF6CA8F1);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontFamily: 'OpenSans',
);

final kErrorStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.red,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kNoErrorBoxDecorationStyle = BoxDecoration(
  color: Colors.green,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kErrorBoxDecorationStyle = BoxDecoration(
  color: Colors.red,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final BoxDecoration kBackgroundBoxStyle = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF73AEF5),
      Color(0xFF61A4F1),
      Color(0xFF478DE0),
      Color(0xFF398AE5),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),
);

final kTextStyleRegular = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

final kTextStyleRegularSubtitle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 15.0,
);

final kButtonStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.all(15.0),
  elevation: 5.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  ),
);

final kRegularIconColor = Colors.black45;
