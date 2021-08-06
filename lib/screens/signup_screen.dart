import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/validator.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:cheque_app/widgets/build_select_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
  BuildSelectProducts _buildSelectProducts = BuildSelectProducts();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Validator _validator = Validator();

  bool _canAddParty = false;

  bool _showPassword = false;

  bool _isLoading = false;

  List<String> _roleOptions = [
    'Sales',
    'Accountant',
  ];

  List<dynamic> _selectedProducts = [];

  late UserModel _user;

  late String _selectedRole;

  late bool _canEditOrderStatus = false;

  Widget _buildShowPasswordCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.white,
            ),
            child: Checkbox(
              value: _showPassword,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _showPassword = value!;
                });
              },
            ),
          ),
          Text(
            'Show password',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: kButtonStyle,
        onPressed: !_isLoading
            ? () async {
                setState(() {
                  _isLoading = true;
                });
                if (_nameController.text == '' ||
                    _emailController.text == '' ||
                    _passwordController.text == '' ||
                    _confirmPasswordController.text == '' ||
                    (_selectedProducts.isEmpty &&
                        _selectedRole == _roleOptions.first)) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All fields are necessary'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  if (_validator.validateEmail(_emailController.text) != '' ||
                      _validator.validatePassword(_passwordController.text) !=
                          '') {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid email or password'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password fields do not match'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      _user = UserModel(
                        name: _nameController.text.toLowerCase(),
                        email: _emailController.text,
                        role: _selectedRole,
                        registerDate: DateTime.now(),
                        products: _selectedProducts,
                        canAddParty: _canAddParty,
                        canEditOrderStatus: _canEditOrderStatus,
                      );
                      var _error = await _firebaseServices
                          .createAccount(
                              userDetail: _user,
                              password: _passwordController.text)
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                          Navigator.pop(context);
                        });
                      });
                      if (_error != '') {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$_error'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  }
                }
              }
            : null,
        child: Text(
          'Sign Up',
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

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: !_isLoading
          ? () {
              Navigator.pop(context);
            }
          : null,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _selectedRole = _roleOptions.first;
    super.initState();
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
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    BuildInput(
                      fieldName: 'Username',
                      hintText: 'Enter your username',
                      controller: _nameController,
                      textInputType: TextInputType.name,
                      passwordfield: false,
                      icon: Icon(
                        Icons.person,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Role',
                          style: kLabelStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          alignment: Alignment.centerLeft,
                          decoration: kBoxDecorationStyle,
                          child: Row(
                            children: [
                              if (_selectedRole == _roleOptions.first)
                                Icon(
                                  Icons.group_outlined,
                                  color: kRegularIconColor,
                                ),
                              if (_selectedRole == _roleOptions[1])
                                Icon(
                                  Icons.person_outline,
                                  color: kRegularIconColor,
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton<String>(
                                focusColor: kRegularColor,
                                dropdownColor: kRegularColor,
                                value: _selectedRole,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: kLabelStyle,
                                underline: Container(
                                  decoration: kBoxDecorationStyle,
                                  alignment: Alignment.center,
                                  height: 0,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRole = newValue!;
                                    if (_selectedRole == _roleOptions[1]) {
                                      _selectedProducts = [];
                                      _canAddParty = true;
                                      _canEditOrderStatus = true;
                                    } else {
                                      _canAddParty = false;
                                      _canEditOrderStatus = false;
                                    }
                                  });
                                },
                                items: _roleOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: kLabelStyle,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_selectedRole == _roleOptions.first) ...[
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Products',
                            style: kLabelStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            alignment: Alignment.centerLeft,
                            decoration: kBoxDecorationStyle,
                            height: 60.0,
                            child: GestureDetector(
                              onTap: _selectedRole == _roleOptions.first
                                  ? () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return _buildSelectProducts;
                                        },
                                      ).whenComplete(() {
                                        setState(() {
                                          _selectedProducts =
                                              _buildSelectProducts
                                                  .selectedProducts;
                                        });
                                      });
                                    }
                                  : null,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: kRegularIconColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (_selectedProducts.length == 0)
                                    Center(
                                      child: Text(
                                        'No products selected yet',
                                        style: kHintTextStyle,
                                      ),
                                    ),
                                  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: _selectedProducts.length,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: kBoxDecorationStyle,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            '${_selectedProducts[index]}',
                                            style: kLabelStyle,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 20.0,
                    ),
                    BuildInput(
                      fieldName: 'Email',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      passwordfield: false,
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    BuildInput(
                      fieldName: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      textInputType: TextInputType.visiblePassword,
                      passwordfield: !_showPassword,
                      icon: Icon(
                        Icons.lock,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    BuildInput(
                      fieldName: 'Confirm Password',
                      hintText: 'Confirm password',
                      controller: _confirmPasswordController,
                      textInputType: TextInputType.visiblePassword,
                      passwordfield: !_showPassword,
                      icon: Icon(
                        Icons.lock,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildShowPasswordCheckbox(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Password must contain atleast 8 characters, \n One upper case, One lower case, One digit and, \n One Special character',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                    _buildSignUpBtn(),
                    _buildSignInBtn(),
                    SizedBox(
                      height: 20,
                    )
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
