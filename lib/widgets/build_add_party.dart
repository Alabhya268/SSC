import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:cheque_app/widgets/build_error_dialog.dart';
import 'package:flutter/material.dart';

class BuildAddParty extends StatefulWidget {
  BuildAddParty({Key? key, required this.userModel, required this.productList})
      : super(key: key);
  final UserModel userModel;
  final List<dynamic> productList;

  @override
  _BuildAddPartyState createState() => _BuildAddPartyState();
}

class _BuildAddPartyState extends State<BuildAddParty> {
  FirebaseServices _firebaseServices = FirebaseServices();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _limitController = TextEditingController();
  late String _selectedProduct;

  @override
  void initState() {
    _selectedProduct = widget.productList.isNotEmpty
        ? widget.productList.first
        : 'No products';
    print(widget.productList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.productList.isEmpty
        ? BuildErrorDialog(
            title: 'Alert',
            errorMessage:
                'No products exist yet, products need to be added before adding party')
        : AlertDialog(
            backgroundColor: kRegularColor,
            title: Text(
              'Add Party',
              style: kLabelStyle,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  BuildInput(
                    fieldName: 'Party name',
                    hintText: 'Enter name of party',
                    controller: _nameController,
                    textInputType: TextInputType.name,
                    passwordfield: false,
                    icon: Icon(Icons.group),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BuildInput(
                    fieldName: 'Party location',
                    hintText: 'Enter party location',
                    controller: _locationController,
                    textInputType: TextInputType.name,
                    passwordfield: false,
                    icon: Icon(
                      Icons.location_pin,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BuildInput(
                    fieldName: 'Limit',
                    hintText: 'Enter limit',
                    controller: _limitController,
                    textInputType: TextInputType.number,
                    passwordfield: false,
                    icon: Icon(Icons.credit_card),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select product',
                        style: kLabelStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: kRegularIconColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton<dynamic>(
                              dropdownColor: kRegularColor,
                              value: _selectedProduct,
                              items: widget.userModel.role == 'Admin' ||
                                      widget.userModel.role == 'Accountant'
                                  ? widget.productList.map((dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: kLabelStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList()
                                  : widget.userModel.products
                                      .map((dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: kLabelStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                              underline: Container(
                                decoration: kBoxDecorationStyle,
                                alignment: Alignment.center,
                                height: 0,
                              ),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  _selectedProduct = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Add',
                    style: kLabelStyle,
                  ),
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _limitController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('All fields are necessary'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (await _firebaseServices.doesPartyAlreadyExist(
                        name: _nameController.text.toLowerCase(),
                        location: _locationController.text.toLowerCase())) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return BuildErrorDialog(
                            title: 'Alert',
                            errorMessage:
                                'Party with similar name and location exists already',
                          );
                        },
                      );
                    } else {
                      _firebaseServices
                          .addToParty(
                            partyLocation:
                                _locationController.text.toLowerCase(),
                            partyName: _nameController.text.toLowerCase(),
                            product: _selectedProduct,
                            limit: double.parse(_limitController.text),
                          )
                          .whenComplete(() => Navigator.of(context).pop());
                    }
                  }),
              TextButton(
                child: Text(
                  'Cancel',
                  style: kLabelStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}
