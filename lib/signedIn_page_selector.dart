import 'package:cheque_app/models/token_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/products_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/members_list_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/parties_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/user_approved_screen.dart';
import 'services/messaging_service.dart';
import 'utilities/constants.dart';
import 'utilities/extension.dart';

class SignInPageSelector extends StatefulWidget {
  const SignInPageSelector({Key? key}) : super(key: key);

  @override
  _SignInPageSelectorState createState() => _SignInPageSelectorState();
}

class _SignInPageSelectorState extends State<SignInPageSelector> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MessagingServices _messagingServices = MessagingServices();
  int _screenNumberSignedIn = 0;
  String _token = '';

  void _tokenWorkFlow(List<dynamic> products, String token) async {
    _firebaseServices.doesTokenAlreadyExist(token: token).then((value) {
      if (value) {
        _firebaseServices.getTokenDetail(token: token).then((value) {
          TokenModel _tokenModel = value;
          if (value.products != products) {
            _firebaseServices.updateTokenProduct(
                product: products, id: _tokenModel.id);
          }
        });
      } else {
        TokenModel _tokenModel = TokenModel(token: token, products: products);
        if (_tokenModel.token != '') {
          _firebaseServices.addToToken(tokenModel: _tokenModel);
        }
      }
    });
  }

  void _getToken() async {
    _token = (await _messagingServices.getDeviceToken())!;
  }

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Widget screenSignedIn(int _screenNumberSignedIn) {
    switch (_screenNumberSignedIn) {
      case 0:
        return PartiesScreen();
      case 1:
        return MembersListScreen();
      case 2:
        return EmailVerificationScreen();
      case 3:
        return UserApprovedScreen();
      case 4:
        return SalesScreen();
      case 5:
        return ProductListScreen();
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

    if (_isApproved && _isUserVerified) {
      _tokenWorkFlow(_userModel.products, _token);
    }

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
                            leading: Icon(
                              Icons.group_outlined,
                              color: _screenNumberSignedIn == 0
                                  ? kRegularColor
                                  : kRegularIconColor,
                            ),
                            title: Text('Parties'),
                            onTap: () {
                              setState(() {
                                _screenNumberSignedIn = 0;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          if (_userModel.role == 'Admin') ...[
                            ListTile(
                              leading: Icon(
                                Icons.people_alt_outlined,
                                color: _screenNumberSignedIn == 1
                                    ? kRegularColor
                                    : kRegularIconColor,
                              ),
                              title: Text('Members'),
                              onTap: () {
                                setState(() {
                                  _screenNumberSignedIn = 1;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.shopping_cart,
                                color: _screenNumberSignedIn == 4
                                    ? kRegularColor
                                    : kRegularIconColor,
                              ),
                              title: Text('Sales'),
                              onTap: () {
                                setState(() {
                                  _screenNumberSignedIn = 4;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.shopping_bag,
                                color: _screenNumberSignedIn == 5
                                    ? kRegularColor
                                    : kRegularIconColor,
                              ),
                              title: Text('Products'),
                              onTap: () {
                                setState(() {
                                  _screenNumberSignedIn = 5;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text('About'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'SSC',
                                applicationIcon: Image.asset(
                                  'assets/logos/launcher_icon.png',
                                  height: 40,
                                ),
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
              ? screenSignedIn(_screenNumberSignedIn)
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
