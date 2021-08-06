import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:cheque_app/widgets/build_select_products.dart';
import 'package:flutter/material.dart';

class BuildUpdateMemberDetail extends StatefulWidget {
  final List<dynamic> products;
  final bool canAddParty;
  final String role;
  final String uid;
  final bool approved;
  final int orders;
  const BuildUpdateMemberDetail({
    Key? key,
    required this.role,
    required this.uid,
    required this.approved,
    required this.products,
    required this.canAddParty,
    required this.orders,
  }) : super(key: key);

  @override
  _BuildUpdateMemberDetailState createState() =>
      _BuildUpdateMemberDetailState();
}

class _BuildUpdateMemberDetailState extends State<BuildUpdateMemberDetail> {
  BuildSelectProducts _buildSelectProducts = BuildSelectProducts();
  FirebaseServices _firebaseServices = FirebaseServices();
  TextEditingController _orderController = TextEditingController();
  late String _role;
  late bool _approved;
  late bool _canAddParty;
  List<String> _roleOptions = [
    'Sales',
    'Accountant',
  ];
  List<dynamic> _selectedProducts = [];

  @override
  void initState() {
    _role = widget.role;
    _approved = widget.approved;
    _selectedProducts = widget.products;
    _buildSelectProducts.selectedProducts = _selectedProducts;
    _canAddParty = widget.canAddParty;
    _orderController.text = widget.orders.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Add Party', style: kLabelStyle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
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
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: Row(
                    children: [
                      if (_role == _roleOptions.first)
                        Icon(
                          Icons.person,
                          color: kRegularIconColor,
                        ),
                      if (_role == _roleOptions[1])
                        Icon(
                          Icons.person_outline,
                          color: kRegularIconColor,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        dropdownColor: kRegularColor,
                        value: _role,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
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
                            _role = newValue!;
                            if (_role == _roleOptions[1]) {
                              _selectedProducts = [];
                            }
                          });
                        },
                        items: _roleOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kLabelStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_role == _roleOptions[0]) ...[
              SizedBox(
                height: 30,
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
                  GestureDetector(
                    onTap: _role == _roleOptions.first
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
                                    _buildSelectProducts.selectedProducts;
                              });
                            });
                          }
                        : null,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      height: 60.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: kRegularIconColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (_selectedProducts.isEmpty)
                              Text(
                                'No products selected yet',
                                style: kHintTextStyle,
                              ),
                            Row(
                              children: [
                                for (int i = 0;
                                    i < _selectedProducts.length;
                                    i++) ...[
                                  Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: kBoxDecorationStyle,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        '${_selectedProducts[i]}',
                                        style: kLabelStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Can add party',
                    style: kLabelStyle,
                    overflow: TextOverflow.ellipsis,
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
                        Checkbox(
                          value: _canAddParty,
                          checkColor: Colors.green,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _canAddParty = value as bool;
                            });
                          },
                        ),
                        Text(
                          _canAddParty ? 'Can add party' : 'Can\'t add party',
                          style: kLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
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
                      Checkbox(
                        value: _approved,
                        checkColor: Colors.green,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _approved = value as bool;
                          });
                        },
                      ),
                      Text(
                        _approved ? 'Approved' : 'Not Approved',
                        style: kLabelStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            BuildInput(
              fieldName: 'Orders',
              hintText: 'Number of orders',
              controller: _orderController,
              textInputType: TextInputType.number,
              passwordfield: false,
              icon: Icon(
                Icons.format_list_numbered,
                color: kRegularIconColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              'Update',
              style: kLabelStyle,
            ),
            onPressed: () async {
              if (_selectedProducts.isEmpty && _role == _roleOptions.first) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Atleast one product need to be selected for sales role'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                await _firebaseServices
                    .updateUserDetails(
                      canAddParty: _canAddParty,
                      products: _selectedProducts,
                      uid: widget.uid,
                      approved: _approved,
                      role: _role,
                      orders: int.parse(_orderController.text),
                    )
                    .whenComplete(() => Navigator.of(context).pop())
                    .onError((error, stackTrace) => print(error));
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
