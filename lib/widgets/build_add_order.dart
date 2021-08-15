import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';

class BuildAddOrder extends StatefulWidget {
  final double credit;
  final PartiesModel partiesModel;
  final UserModel userModel;
  const BuildAddOrder({
    Key? key,
    required this.partiesModel,
    required this.userModel,
    required this.credit,
  }) : super(key: key);

  @override
  _BuildAddOrderState createState() => _BuildAddOrderState();
}

class _BuildAddOrderState extends State<BuildAddOrder> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();
  String _statusValue = 'Pending';
  List<String> _statusOptions = [
    'Pending',
    'Approved',
  ];
  TextEditingController _numberOfUnits = TextEditingController();
  TextEditingController _perUnitAmount = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _billed = false;
  TextEditingController _tax = TextEditingController();
  TextEditingController _extraCharges = TextEditingController();
  DateTime _statusDate = DateTime.now();
  DateTime _issueDate = DateTime.now();
  double _totalOrderAmount = 0;

  late OrdersModel _orderModel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text(
        'Add order',
        style: kLabelStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BuildInput(
              fieldName: 'Number of units',
              hintText: 'Enter number of units',
              controller: _numberOfUnits,
              textInputType: TextInputType.number,
              passwordfield: false,
              noSpace: true,
              icon: Icon(
                Icons.format_list_numbered,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BuildInput(
              fieldName: 'Unit amount',
              hintText: 'Enter unit amount',
              controller: _perUnitAmount,
              textInputType: TextInputType.number,
              passwordfield: false,
              noSpace: true,
              icon: Icon(
                Icons.money,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BuildInput(
              fieldName: 'Extra charges',
              hintText: 'Enter extra charges',
              controller: _extraCharges,
              textInputType: TextInputType.number,
              passwordfield: false,
              noSpace: true,
              icon: Icon(
                Icons.money,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billed',
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
                        value: _billed,
                        checkColor: Colors.green,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _billed = value as bool;
                          });
                        },
                      ),
                      Text(
                        _billed ? 'Billed' : 'Not Billed',
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
            if (_billed) ...[
              BuildInput(
                fieldName: 'Tax',
                hintText: 'Enter Tax',
                controller: _tax,
                textInputType: TextInputType.number,
                passwordfield: false,
                noSpace: true,
                icon: Icon(
                  Icons.money,
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
            BuildInput(
              fieldName: 'Description',
              hintText: 'Enter description',
              controller: _description,
              textInputType: TextInputType.multiline,
              passwordfield: false,
              icon: Icon(
                Icons.money,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Issue Date',
                  style: kLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: TextButton.icon(
                    onPressed: () async {
                      var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime(DateTime.now().year - DateTime(5).year),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _issueDate = pickedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text(_miscFunctions.formattedDate(_issueDate),
                        style: kLabelStyle),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (widget.userModel.canEditOrderStatus ||
                widget.userModel.role == 'Accountant' ||
                widget.userModel.role == 'Admin') ...[
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
                        if (_statusValue == _statusOptions.first)
                          Icon(
                            Icons.pending_outlined,
                            color: kRegularIconColor,
                          ),
                        if (_statusValue == _statusOptions[1])
                          Icon(
                            Icons.check,
                            color: kRegularIconColor,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          dropdownColor: kRegularColor,
                          value: _statusValue,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: kLabelStyle,
                          underline: Container(
                            decoration: kBoxDecorationStyle,
                            alignment: Alignment.center,
                            height: 0,
                          ),
                          onChanged: (String? newValue) async {
                            setState(() {
                              _statusValue = newValue!;
                            });
                          },
                          items: _statusOptions
                              .map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Status Date',
                        style: kLabelStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        child: TextButton.icon(
                          onPressed: () async {
                            var pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  DateTime.now().year - DateTime(5).year),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(
                                () {
                                  _statusDate = pickedDate;
                                },
                              );
                            }
                          },
                          icon: Icon(Icons.date_range_outlined,
                              color: kRegularIconColor),
                          label: Text(_miscFunctions.formattedDate(_statusDate),
                              style: kLabelStyle),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Add',
            style: kLabelStyle,
          ),
          onPressed: () {
            if (_tax.text.isEmpty) {
              _tax.text = '0';
            }
            if (_extraCharges.text.isEmpty) {
              _extraCharges.text = '0';
            }
            if (_numberOfUnits.text.isEmpty || _perUnitAmount.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Number of units and Unit amount is required'),
                  duration: Duration(seconds: 1),
                ),
              );
            } else {
              double _principle = double.parse(_perUnitAmount.text) *
                  double.parse(_numberOfUnits.text);
              double _taxOnPrinciple = double.parse(_perUnitAmount.text) *
                  double.parse(_numberOfUnits.text) *
                  double.parse(_tax.text) *
                  0.01;
              _totalOrderAmount = _principle +
                  _taxOnPrinciple +
                  double.parse(_extraCharges.text);
              if (_totalOrderAmount > widget.credit &&
                  _statusValue == _statusOptions[1]) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: kRegularColor,
                      title: Text(
                        'Error',
                        style: kLabelStyle,
                      ),
                      content: SingleChildScrollView(
                        child: Text(
                          'Total amount of order: $_totalOrderAmount \n Remaining credit: ${widget.credit}',
                          style: kLabelStyle,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Ok',
                            style: kLabelStyle,
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                _orderModel = OrdersModel(
                  partyId: widget.partiesModel.id,
                  name: widget.partiesModel.name,
                  uid: _firebaseServices.getCurrentUserId(),
                  product: widget.partiesModel.product,
                  perUnitAmount: double.parse(_perUnitAmount.text),
                  numberOfUnits: double.parse(_numberOfUnits.text),
                  status: _statusValue,
                  description: _description.text,
                  billed: _billed,
                  tax: double.parse(_tax.text),
                  extraCharges: double.parse(_extraCharges.text),
                  issueDate: _issueDate,
                  statusDate: _statusDate,
                );
                _firebaseServices
                    .addToOrder(orderModel: _orderModel)
                    .whenComplete(
                  () async {
                    if (_statusValue == _statusOptions[1]) {
                      return _firebaseServices
                          .updateUserOrders(
                              uid: widget.userModel.uid,
                              orders: await _firebaseServices.getUserOrders(
                                      _firebaseServices.getCurrentUserId()) +
                                  1)
                          .whenComplete(() => Navigator.of(context).pop());
                    }
                    Navigator.of(context).pop();
                  },
                );
              }
            }
          },
        ),
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
