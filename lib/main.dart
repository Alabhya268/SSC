import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: _firebaseServices.firebaseAuth.userChanges(),
          initialData: null,
          catchError: (context, snapshot) {
            return null;
          },
        ),
        StreamProvider<List<dynamic>>.value(
          value: _firebaseServices.getProducts,
          initialData: [],
          catchError: (context, snapshot) {
            return [];
          },
        ),
      ],
      child: MaterialApp(
        title: 'SSC',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
