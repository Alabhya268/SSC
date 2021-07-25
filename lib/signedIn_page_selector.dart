import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/members_list_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/parties_list_screen.dart';
import 'screens/user_approved_screen.dart';
import 'utilities/constants.dart';
import 'utilities/extension.dart';

class SignInPageSelector extends StatefulWidget {
  const SignInPageSelector({Key? key}) : super(key: key);

  @override
  _SignInPageSelectorState createState() => _SignInPageSelectorState();
}

class _SignInPageSelectorState extends State<SignInPageSelector> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int screenNumberSignedIn = 0;

  Widget screenSignedIn(int screenNumberSignedIn) {
    switch (screenNumberSignedIn) {
      case 0:
        return PartiesScreen();
      case 1:
        return MembersListScreen();
      case 2:
        return EmailVerificationScreen();
      case 3:
        return UserApprovedScreen();
      default:
        return PartiesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<User?>(context);
    bool _isApproved = Provider.of<bool>(context);
    bool _isUserVerified = _user!.emailVerified;
    UserModel _userModel = Provider.of<UserModel>(context);

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
      drawer: _isUserVerified
          ? _isApproved
              ? Drawer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Color(0xFF73AEF5),
                            ),
                            child: ListTile(
                              title: Text(
                                '${_userModel.name.capitalizeFirstofEach}',
                                style: kTextStyleRegular,
                              ),
                              subtitle: Text(
                                '${_userModel.role}',
                                style: kTextStyleRegularSubtitle,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.group_outlined),
                            title: Text('Parties'),
                            onTap: () {
                              setState(() {
                                screenNumberSignedIn = 0;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          if (_userModel.role == 'Admin')
                            ListTile(
                              leading: Icon(Icons.people_alt_outlined),
                              title: Text('Members'),
                              onTap: () {
                                setState(() {
                                  screenNumberSignedIn = 1;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('About'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'SSC',
                                applicationIcon: FlutterLogo(),
                                applicationVersion: '1.0.0',
                                children: [
                                  Text('Developed by: Alabhya Singh'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text('Signout'),
                        onTap: () {
                          _firebaseServices.firebaseAuth.signOut();
                        },
                      ),
                    ],
                  ),
                )
              : null
          : null,
      body: _isUserVerified
          ? _isApproved == true
              ? screenSignedIn(screenNumberSignedIn)
              : _isApproved == false
                  ? screenSignedIn(3)
                  : Center(
                      child: CircularProgressIndicator(),
                    )
          : _isUserVerified == false
              ? screenSignedIn(2)
              : Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
